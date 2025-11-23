// ==UserScript==
// @name         ESPN Fantasy Defense Fetcher
// @namespace    http://tampermonkey.net/
// @version      2024-11-04
// @description  Fetch available defenses from ESPN Fantasy API on Subvertadown
// @author       You
// @match        https://subvertadown.com/*
// @match        http://subvertadown.com/*
// @icon         https://www.google.com/s2/favicons?sz=64&domain=espn.com
// @grant        GM_xmlhttpRequest
// @grant        GM_setValue
// @grant        GM_getValue
// @connect      lm-api-reads.fantasy.espn.com
// ==/UserScript==

(function() {
    'use strict';

    // Configuration
    const API_BASE_URL = 'https://lm-api-reads.fantasy.espn.com/apis/v3/games/ffl';
    const CURRENT_SEASON = 2024;
    const STORAGE_KEY = 'espn_league_id';

    // Position Slot IDs
    const SLOT_DST = 16;

    // Team ID to Name mapping (NFL teams)
    const NFL_TEAMS = {
        1: "ATL", 2: "BUF", 3: "CHI", 4: "CIN", 5: "CLE",
        6: "DAL", 7: "DEN", 8: "DET", 9: "GB", 10: "TEN",
        11: "IND", 12: "KC", 13: "LV", 14: "LAR", 15: "MIA",
        16: "MIN", 17: "NE", 18: "NO", 19: "NYG", 20: "NYJ",
        21: "PHI", 22: "ARI", 23: "PIT", 24: "LAC", 25: "SF",
        26: "SEA", 27: "TB", 28: "WSH", 29: "CAR", 30: "JAX",
        33: "BAL", 34: "HOU"
    };

    /**
     * Fetch available defenses from ESPN Fantasy API
     */
    async function fetchAvailableDefenses(leagueId, scoringPeriodId = null) {
        if (!leagueId) {
            leagueId = prompt('Enter your ESPN Fantasy League ID:', GM_getValue(STORAGE_KEY, ''));
            if (!leagueId) {
                console.error('[ESPN Defense Fetcher] No league ID provided');
                return;
            }
            GM_setValue(STORAGE_KEY, leagueId);
        }

        console.log(`[ESPN Defense Fetcher] Fetching available defenses for league ${leagueId}...`);

        // Build the URL
        let url = `${API_BASE_URL}/seasons/${CURRENT_SEASON}/segments/0/leagues/${leagueId}`;

        // Add view parameter for player info
        url += '?view=kona_player_info';

        // Build the filter for free agent defenses
        const filter = {
            players: {
                filterStatus: {
                    value: ["FREEAGENT", "WAIVERS"]
                },
                filterSlotIds: {
                    value: [SLOT_DST]
                },
                sortPercOwned: {
                    sortPriority: 1,
                    sortAsc: false
                },
                limit: 50
            }
        };

        // Add scoring period filter if provided
        if (scoringPeriodId) {
            filter.players.filterRanksForScoringPeriodIds = {
                value: [scoringPeriodId]
            };
        }

        return new Promise((resolve, reject) => {
            GM_xmlhttpRequest({
                method: 'GET',
                url: url,
                headers: {
                    'X-Fantasy-Filter': JSON.stringify(filter),
                    'Accept': 'application/json'
                },
                onload: function(response) {
                    try {
                        if (response.status !== 200) {
                            throw new Error(`HTTP ${response.status}: ${response.statusText}`);
                        }

                        const data = JSON.parse(response.responseText);
                        console.log('[ESPN Defense Fetcher] Raw API Response:', data);

                        // Extract and format defense data
                        const defenses = extractDefenseData(data);
                        displayDefenses(defenses);

                        resolve(defenses);
                    } catch (error) {
                        console.error('[ESPN Defense Fetcher] Error parsing response:', error);
                        console.error('[ESPN Defense Fetcher] Response text:', response.responseText);
                        reject(error);
                    }
                },
                onerror: function(error) {
                    console.error('[ESPN Defense Fetcher] Request failed:', error);
                    reject(error);
                }
            });
        });
    }

    /**
     * Extract defense data from API response
     */
    function extractDefenseData(apiResponse) {
        const defenses = [];

        // Check if players data exists
        if (!apiResponse.players) {
            console.warn('[ESPN Defense Fetcher] No players data in response');
            return defenses;
        }

        apiResponse.players.forEach(playerEntry => {
            const player = playerEntry.player;

            if (player.defaultPositionId === SLOT_DST) {
                const defense = {
                    id: player.id,
                    name: player.fullName,
                    teamAbbr: NFL_TEAMS[player.proTeamId] || `Team${player.proTeamId}`,
                    proTeamId: player.proTeamId,
                    status: playerEntry.status || 'FREEAGENT',
                    ownership: playerEntry.ratings ? playerEntry.ratings['0']?.percentOwned : 0,
                    stats: extractStats(player.stats),
                    rankings: playerEntry.ratings ? playerEntry.ratings['0'] : null,
                    playerPoolEntry: playerEntry
                };

                defenses.push(defense);
            }
        });

        return defenses;
    }

    /**
     * Extract relevant stats from player stats array
     */
    function extractStats(stats) {
        if (!stats || !Array.isArray(stats)) {
            return { actual: null, projected: null };
        }

        const result = {
            actual: null,
            projected: null
        };

        stats.forEach(statEntry => {
            if (statEntry.statSourceId === 0) {
                // Actual stats
                result.actual = {
                    scoringPeriodId: statEntry.scoringPeriodId,
                    points: statEntry.appliedTotal || 0,
                    stats: statEntry.stats || {}
                };
            } else if (statEntry.statSourceId === 1) {
                // Projected stats
                result.projected = {
                    scoringPeriodId: statEntry.scoringPeriodId,
                    points: statEntry.appliedTotal || 0,
                    stats: statEntry.stats || {}
                };
            }
        });

        return result;
    }

    /**
     * Display defenses in console
     */
    function displayDefenses(defenses) {
        console.log('%c========================================', 'color: #06F; font-weight: bold');
        console.log('%cESPN FANTASY - AVAILABLE DEFENSES', 'color: #06F; font-weight: bold; font-size: 14px');
        console.log('%c========================================', 'color: #06F; font-weight: bold');
        console.log(`Total available: ${defenses.length}`);
        console.log('');

        if (defenses.length === 0) {
            console.log('No available defenses found.');
            return;
        }

        // Create a formatted table
        const tableData = defenses.map(d => ({
            'Team': d.teamAbbr,
            'Name': d.name,
            'Status': d.status,
            'Owned %': d.ownership ? `${d.ownership.toFixed(1)}%` : 'N/A',
            'Proj Pts': d.stats.projected ? d.stats.projected.points.toFixed(1) : 'N/A',
            'Last Actual': d.stats.actual ? d.stats.actual.points.toFixed(1) : 'N/A',
            'Rank': d.rankings ? d.rankings.positionalRanking : 'N/A'
        }));

        console.table(tableData);
        console.log('');
        console.log('%cDetailed Data:', 'color: #06F; font-weight: bold');
        console.log('Full defense objects are available in the array above');
        console.log('');

        // Log the full data for detailed inspection
        defenses.forEach((d, idx) => {
            console.groupCollapsed(`${idx + 1}. ${d.teamAbbr} - ${d.name}`);
            console.log('Full Data:', d);
            console.log('Player Pool Entry:', d.playerPoolEntry);
            console.groupEnd();
        });

        console.log('%c========================================', 'color: #06F; font-weight: bold');
    }

    /**
     * Create floating button UI
     */
    function createButton() {
        const button = document.createElement('button');
        button.id = 'espn-defense-fetcher-btn';
        button.textContent = 'Fetch ESPN Defenses';
        button.style.cssText = `
            position: fixed;
            bottom: 20px;
            right: 20px;
            z-index: 10000;
            padding: 12px 20px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
            transition: all 0.3s ease;
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
        `;

        button.addEventListener('mouseenter', () => {
            button.style.transform = 'translateY(-2px)';
            button.style.boxShadow = '0 6px 16px rgba(0, 0, 0, 0.2)';
        });

        button.addEventListener('mouseleave', () => {
            button.style.transform = 'translateY(0)';
            button.style.boxShadow = '0 4px 12px rgba(0, 0, 0, 0.15)';
        });

        button.addEventListener('click', async () => {
            button.disabled = true;
            button.textContent = 'Fetching...';

            try {
                const leagueId = GM_getValue(STORAGE_KEY, null);
                await fetchAvailableDefenses(leagueId);
                button.textContent = '✓ Fetched!';
                setTimeout(() => {
                    button.textContent = 'Fetch ESPN Defenses';
                }, 2000);
            } catch (error) {
                button.textContent = '✗ Error';
                console.error('[ESPN Defense Fetcher] Error:', error);
                setTimeout(() => {
                    button.textContent = 'Fetch ESPN Defenses';
                }, 2000);
            } finally {
                button.disabled = false;
            }
        });

        document.body.appendChild(button);
        console.log('[ESPN Defense Fetcher] Button added to page');
    }

    /**
     * Initialize the userscript
     */
    function init() {
        console.log('[ESPN Defense Fetcher] Script loaded on', window.location.href);

        // Create button when DOM is ready
        if (document.readyState === 'loading') {
            document.addEventListener('DOMContentLoaded', createButton);
        } else {
            createButton();
        }

        // Expose function to window for console access
        window.fetchAvailableDefenses = fetchAvailableDefenses;

        console.log('[ESPN Defense Fetcher] Available commands:');
        console.log('  - fetchAvailableDefenses(leagueId) // Fetch defenses for specific league');
        console.log('  - fetchAvailableDefenses() // Will prompt for league ID if not saved');

        // Show saved league ID if exists
        const savedLeagueId = GM_getValue(STORAGE_KEY, null);
        if (savedLeagueId) {
            console.log(`  - Saved League ID: ${savedLeagueId}`);
        }
    }

    // Start the script
    init();
})();
