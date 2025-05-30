// ==UserScript==
// @name         ESPN
// @namespace    http://tampermonkey.net/
// @version      2024-04-11
// @description  Highlight DAL games
// @author       You
// @match        https://www.espn.com/*
// @icon         https://www.google.com/s2/favicons?sz=64&domain=google.com
// @grant        none
// ==/UserScript==

(function () {
  'use strict';
  window.setTimeout(() => {
    const nodes = document.querySelectorAll('.cscore_link');
    nodes.forEach(node => {
      if (node.innerText.includes('DAL')) {
        node.style.border = '1px solid red';
      }
    });
  }, 1000);
})();
