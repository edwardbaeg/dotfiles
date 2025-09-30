-- Toggle Feature Abstraction Module ----------------------------------------
--------------------------------------------------------------------------
-- Provides common functionality for creating toggleable features with:
-- - Persistent settings using hs.settings
-- - Menubar item with state display
-- - URL event handlers with parameter-based actions
-- - Enable/disable/toggle functions

local M = {}

-- Creates a new toggle feature instance
-- @param config table Configuration object with the following fields:
--   - name: string - Used for URL event binding (e.g., "autoreload")
--   - abbreviation: string - Abbreviation shown in menubar (e.g., "AR")
--   - settingsKey: string - Key for hs.settings persistence
--   - onEnable: function - Called when feature is enabled
--   - onDisable: function - Called when feature is disabled
--   - defaultState: boolean - Default state if no saved setting (default: false)
--   - registryName: string (optional) - If provided, auto-register with feature registry
-- @return table - Toggle feature instance
function M.new(config)
    -- Validate required config
    assert(config.name, "config.name is required")
    assert(config.abbreviation, "config.abbreviation is required")
    assert(config.settingsKey, "config.settingsKey is required")
    assert(config.onEnable, "config.onEnable is required")
    assert(config.onDisable, "config.onDisable is required")

    local instance = {
        config = config,
        menubar = hs.menubar.new()
    }

    -- Check if feature is currently enabled
    function instance.isEnabled()
        local state = hs.settings.get(config.settingsKey)
        return state == nil and (config.defaultState or false) or state
    end

    -- Update menubar display and save state
    local function setDisplay(state)
        if instance.menubar then
            -- Use standardized format: "ABBR ✓" or "ABBR ✗"
            local status = state and "✓" or "✗"
            local title = config.abbreviation .. " " .. status
            instance.menubar:setTitle(title)
            -- Save state to settings
            hs.settings.set(config.settingsKey, state)
        end
    end

    -- Enable the feature
    function instance.enable()
        setDisplay(true)
        config.onEnable()
    end

    -- Disable the feature
    function instance.disable()
        setDisplay(false)
        config.onDisable()
    end

    -- Toggle the feature state
    function instance.toggle()
        if instance.isEnabled() then
            instance.disable()
        else
            instance.enable()
        end
    end

    -- Get menubar instance (for advanced customization if needed)
    function instance.getMenubar()
        return instance.menubar
    end

    -- Set up menubar click callback
    if instance.menubar then
        instance.menubar:setClickCallback(instance.toggle)
    end

    -- Set up URL event handler with parameter-based actions
    hs.urlevent.bind(config.name, function(_eventName, params)
        local action = params and params.action or "toggle"

        if action == "enable" then
            instance.enable()
        elseif action == "disable" then
            instance.disable()
        elseif action == "toggle" then
            instance.toggle()
        else
            hs.alert("Invalid action: " .. tostring(action) .. ". Use enable, disable, or toggle.")
        end
    end)

    -- Initialize from saved state
    local savedState = instance.isEnabled()
    setDisplay(savedState)

    -- Auto-register with feature registry if registryName provided
    if config.registryName then
        local registry = require("common.feature_registry")
        registry.register(config.registryName, instance)
    end

    return instance
end

return M
