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

// TODO?: use TS source file
(function () {
  'use strict';

  let curr = '';
  let count = 0;

  function main() {
    const title = getEmailSubjectTitle();

    // TODO?: encapsulate into a function, detectTitleChanges
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
  if (!alertEl) {
    alertEl = document.createElement('div');
    alertEl.style.border = '1px solid red';
    alertEl.style.borderRadius = '4px';
    alertEl.style.textAlign = 'center';
    alertEl.style.fontSize = '1rem';
    alertEl.style.height = '1.5rem';
    alertEl.style.backgroundColor = 'white';
  }
  alertEl.textContent = '[GMAIL SCRIPT]: ' + message;
  return alertEl;
}

function addScriptAlertBanner({
  emailContentSearchText = 'Copyright',
  alertText,
}) {
  const emailTable = getRootTableContaining(emailContentSearchText);
  const alertEl = createAlertEl(alertText);
  if (emailTable) {
    if (!emailTable.contains(alertEl)) {
      emailTable.parentNode.prepend(alertEl);
    }
  } else {
    console.warn('Email table not found');
  }
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

const _1440_SENDER = '1440';
function filter1440Sponsors() {
  if (!isFromSender(_1440_SENDER)) {
    return;
  }

  addScriptAlertBanner({
    emailContentSearchText: 'hello@join1440',
    alertText: '1440',
  });

  // Fade out sections containing ad messaging
  const spans = document.querySelectorAll('span');
  spans.forEach(span => {
    if (span.textContent.includes('In partnership with')) {
      const parent = span.closest('table');
      // parent.style.border = "2px solid red";

      const secondParent = parent.parentNode.closest('table');
      if (secondParent) {
        // secondParent.style.border = "2px solid red";
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

  addScriptAlertBanner({
    emailContentSearchText: MORNINGBREW_EMAIL_CONTENT,
    alertText: 'Morning Brew',
  });

  // Fade out sections containing ad messaging
  const headers = document.querySelectorAll('h3');
  headers.forEach(header => {
    if (
      header.textContent.toLocaleLowerCase().includes('presented by') ||
      header.textContent.toLocaleLowerCase().includes('together with') ||
      header.textContent.toLocaleLowerCase().includes('games') ||
      header.textContent.toLocaleLowerCase().includes('answer') ||
      header.textContent.toLocaleLowerCase().includes('share the brew')
    ) {
      const parent = header.closest('table');
      // parent.style.border = "2px solid red";
      parent.style.opacity = 0.1;

      // This highlights the whole email table
      // const secondParent = parent.parentNode.closest('table');
      // if (secondParent) {
      //   secondParent.style.border = "2px solid red";
      //   secondParent.style.opacity = 0.1;
      // }
    }
  });
}

function log(message) {
  console.log('[GMAIL SCRIPT]: ' + message);
}

// TODO: come up with something more robust
// maybe search for a specific table?
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
