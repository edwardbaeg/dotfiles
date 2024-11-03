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
  'use strict';

  let curr = '';
  let count = 0;

  function main() {
    const title = getEmailSubjectTitle();

    // TODO: encapsulate into a function, detectTitleChanges
    if (!title) {
      log('no title');
      return;
    } else {
      log('title: ' + title);
    }

    if (title != curr) {
      count = 0;
    }

    if (title == curr && count > 5) {
      return;
    }

    curr = title;
    count++;

    filter1440Sponsors();
    filterMorningBrewSponsors();
  }

  setInterval(main, 1000);
})();

let alertEl = null;
function createAlertEl(message = '<missing title>') {
  console.log({ message })
  if (!alertEl) {
    alertEl = document.createElement('div');
    alertEl.style.border = '1px solid red';
    alertEl.style.textAlign = 'center';
  }
  alertEl.textContent = '[GMAIL SCRIPT]: ' + message;
  return alertEl;
}

function getEmailSubjectTable() {
  const tables = document.querySelectorAll('table');
  for (let table of tables) {
    const spans = table.querySelectorAll('span[email]');
    if (spans.length === 1) {
      return table;
    }
  }
  return null;
}

function isFromSender(searchText) {
  const subjectTable = getEmailSubjectTable();
  return subjectTable?.textContent.includes(searchText);
}

function filter1440Sponsors() {
  // if (!isFromSender("1440 Daily Digest")) {
  //   return;
  // }
  const spans = document.querySelectorAll('span');
  spans.forEach(span => {
    if (span.textContent.includes('In partnership with')) {
      const parent = span.closest('table');
      // parent.style.border = "2px solid red"; // or any other highlight style you prefer

      const secondParent = parent.parentNode.closest('table');
      if (secondParent) {
        // secondParent.style.border = "2px solid red"; // or any other highlight style you prefer
        secondParent.style.opacity = 0.1;
      }
    }
  });
}

const MORNINGBREW_SENDER = 'Morning Brew';
const MORNINGBREW_EMAIL_CONTENT = 'Copyright';
function filterMorningBrewSponsors() {
  if (!isFromSender(MORNINGBREW_SENDER)) {
    return;
  }
  const emailTable = getRootTableContaining(MORNINGBREW_EMAIL_CONTENT);
  const alertEl = createAlertEl('Morning Brew');
  if (emailTable) {
    if (!emailTable.contains(alertEl)) {
      emailTable.prepend(alertEl);
    }
  }

  const headers = document.querySelectorAll('h3');
  headers.forEach(header => {
    if (
      header.textContent.toLocaleLowerCase().includes('presented by') ||
      header.textContent.toLocaleLowerCase().includes('together with')
    ) {
      const parent = header.closest('table');
      // parent.style.border = "2px solid red"; // or any other highlight style you prefer

      const secondParent = parent.parentNode.closest('table');
      if (secondParent) {
        // secondParent.style.border = "2px solid red"; // or any other highlight style you prefer
        secondParent.style.opacity = 0.1;
      }
    }
  });
}

function log(message) {
  console.log('[GMAIL SCRIPT]: ' + message);
}

// TODO: come up with something more robust
function getEmailSubjectTitle() {
  const EMAIL_SUBJECT_TITLE_SELECTOR = '.hP';
  return document.querySelector(EMAIL_SUBJECT_TITLE_SELECTOR)?.textContent;
}

function getRootTableContaining(text) {
  const tds = document.querySelectorAll('td');
  let target = null;
  tds.forEach(td => {
    if (td.textContent.includes(text)) {
      target = td.closest('table');
      return;
    }
  });

  let count = 0;
  while (target && count < 10) {
    count++;
    const parent = target.parentNode.closest('table');
    if (parent) {
      target = parent;
    } else {
      break;
    }
  }

  return target;
}
