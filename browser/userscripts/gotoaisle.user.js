// ==UserScript==
// @name         Go to Aisle
// @namespace    http://tampermonkey.net/
// @version      2025-05-03
// @description  try to take over the world!
// @author       You
// @match        https://discover.gotoaisle.com/offers
// @icon         https://www.google.com/s2/favicons?sz=64&domain=gotoaisle.com
// @grant        none
// ==/UserScript==

(function () {
  "use strict";
  // Draw a red border around "One Free" labeled items
  window.setTimeout(() => {
    console.log('running')
    document.querySelectorAll(".group").forEach((group) => {
      const childDivs = group.querySelectorAll("div");
      childDivs.forEach((childDiv) => {
        if (childDiv.textContent.trim().toLocaleLowerCase() === "one free") {
          group.style.border = "2px solid red"; // Change border as needed
        }
      });
    });
  }, 2000);
})();
