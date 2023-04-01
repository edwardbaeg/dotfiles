// ==UserScript==
// @name         Highlight Mavericks
// @namespace    http://tampermonkey.net/
// @version      0.1
// @description  try to take over the world!
// @author       You
// @match        https://projects.fivethirtyeight.com/2023-nba-predictions/games/
// @icon         https://www.google.com/s2/favicons?sz=64&domain=fivethirtyeight.com
// @grant        none
// ==/UserScript==

(function () {
  'use strict';

  document.querySelectorAll('div.game.pre.DAL').forEach(node => {
    node.style.padding = '4px';
    node.style.border = '4px solid red';
  });
})();
