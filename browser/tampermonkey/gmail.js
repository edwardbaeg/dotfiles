// ==UserScript==
// @name         Gmail stuffs
// @namespace    http://tampermonkey.net/
// @version      2024-08-25
// @description  try to take over the world!
// @author       You
// @match        https://mail.google.com/mail/u/0/*
// @icon         https://www.google.com/s2/favicons?sz=64&domain=tampermonkey.net
// @grant        none
// ==/UserScript==

(function () {
  "use strict";

  let curr = '';

  function main() {
    // TODO: come up with something more robust
    const EMAIL_SUBJECT_TITLE_SELECTOR = '.hP';
    const title = document.querySelector(EMAIL_SUBJECT_TITLE_SELECTOR)?.textContent;

    if (!title) {
      console.log('no title')
      return;
    }

    if (title == curr) {
      return;
    }

    curr = title;

    filter1440Sponsors();
    filterMorningBrewSponsors();
  }

  function filter1440Sponsors() {
    // if (!isFromSender("1440 Daily Digest")) {
    //   return;
    // }
    const spans = document.querySelectorAll("span");
    spans.forEach((span) => {
      if (span.textContent.includes("In partnership with")) {
        const parent = span.closest("table");
        // parent.style.border = "2px solid red"; // or any other highlight style you prefer

        const secondParent = parent.parentNode.closest("table");
        // secondParent.style.border = "2px solid red"; // or any other highlight style you prefer
        secondParent.style.opacity = 0.1;
      }
    });
  }
 
  function filterMorningBrewSponsors() {
    // if (!isFromSender("crew@morningbrew.com")) {
    //   return;
    // }
    const headers = document.querySelectorAll("h3" );
    headers.forEach((header) => {
      if (header.textContent.includes("PRESENTED BY") || header.textContent.includes("TOGETHER WITH")) {
        const parent = header.closest("table");
        // parent.style.border = "2px solid red"; // or any other highlight style you prefer

        const secondParent = parent.parentNode.closest("table");
        // secondParent.style.border = "2px solid red"; // or any other highlight style you prefer
        secondParent.style.opacity = 0.1;
      }
    });
  }

  // TODO: update this to only check the email pane
  function isFromSender(email) {
    return document.body.textContent.includes(email);
  }

  setInterval(main, 1000);
})();
