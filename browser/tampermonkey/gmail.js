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

  function filter1440Sponsors() {
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

    const spans = document.querySelectorAll("span");
    console.log(spans)
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

  setInterval(filter1440Sponsors, 1000);
})();
