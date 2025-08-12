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
(function main() {
  'use strict';

  let curr = '';
  let debounceTimer = null;

  function processCurrentEmail() {
    const title = getEmailSubjectTitle();

    if (!title || title == curr) {
      return;
    }

    curr = title;
    log('title: ' + title);

    filter1440Sponsors();
    filterMorningBrewSponsors();
    highlightUnsubscribe();
  }

  function debouncedProcessEmail() {
    if (debounceTimer) {
      clearTimeout(debounceTimer);
    }
    debounceTimer = setTimeout(processCurrentEmail, 300);
  }

  // Observe changes to Gmail's main content area
  const observer = new MutationObserver(mutations => {
    let shouldProcess = false;

    for (const mutation of mutations) {
      // Check if any changes affect email content or subject areas
      if (mutation.type === 'childList' || mutation.type === 'characterData') {
        // Look for changes in email subject area or content
        const target = mutation.target;
        if (
          target.closest &&
          (target.closest('.hP') || // Email subject
            target.closest('.adn.ads') || // Email content area
            target.closest('table')) // Email tables
        ) {
          shouldProcess = true;
          break;
        }
      }
    }

    if (shouldProcess) {
      debouncedProcessEmail();
    }
  });

  // Start observing when DOM is ready
  function startObserving() {
    const target = document.body || document.documentElement;
    observer.observe(target, {
      childList: true,
      subtree: true,
      characterData: true,
    });

    // Run once initially
    processCurrentEmail();
    log('Gmail script initialized with MutationObserver');
  }

  // Start immediately if DOM is ready, otherwise wait
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', startObserving);
  } else {
    startObserving();
  }
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
const MORNINGBREW_AD_PREFIXES = [
  'presented by',
  'together with',
  'brought to you by',
  'games',
  'answer',
  'share the brew',
];
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
      MORNINGBREW_AD_PREFIXES.some(prefix =>
        header.textContent.toLocaleLowerCase().includes(prefix),
      )
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

function highlightUnsubscribe() {
  // The problem is that not all emails have a table in its email content
  // const table = getEmailTable();
  // if (table) {
  //   table.style.border = '2px solid green';
  // }

  const contentDiv = getEmailContentDiv();

  if (contentDiv) {
    // contentDiv.style.border = '2px solid red';

    const unsubElement = findLastUnsubscribeElement(contentDiv);
    if (unsubElement) {
      unsubElement.style.border = '2px solid red';
    }
  }
}

/**
 * @returns {HTMLTableElement} of the email body, if there is one
 */
function getEmailTable() {
  const span = findToSpan();
  span.style.backgroundColor = 'yellow';
  const table = findNextTable(span);
  return table;
}

function findToSpan() {
  // Select all spans
  const spans = document.querySelectorAll('span');

  // Find the span whose text starts with "to "
  return Array.from(spans).find(span =>
    span.textContent.trim().toLowerCase().startsWith('to '),
  );
}

function findNextTable(startElement) {
  const walker = document.createTreeWalker(
    startElement.getRootNode(),
    NodeFilter.SHOW_ELEMENT,
    null,
    false,
  );

  // Set walker to start from the given element
  walker.currentNode = startElement;

  // Find next table
  while (walker.nextNode()) {
    if (walker.currentNode.tagName.toLowerCase() === 'table') {
      return walker.currentNode;
    }
  }

  return null;
}

function getEmailContentDiv() {
  const adnAdsDiv = document.querySelector('.adn.ads');

  if (!adnAdsDiv) {
    return null;
  }

  const children = adnAdsDiv.children;
  if (children.length < 2) {
    return null;
  }
  const secondChild = children[1];

  const emailContentDiv = secondChild.lastElementChild;
  if (!emailContentDiv) {
    return null;
  }

  return emailContentDiv;
}

function findLastUnsubscribeElement(rootElement) {
  if (!rootElement) {
    return null;
  }

  let lastUnsubscribeElement = null;
  const walker = document.createTreeWalker(
    rootElement,
    NodeFilter.SHOW_ELEMENT,
    null,
    false,
  );

  while (walker.nextNode()) {
    const element = walker.currentNode;
    const elementText = element.textContent?.toLowerCase() || '';

    if (elementText.includes('unsubscribe')) {
      const hasChildElements = element.children.length > 0;
      const hasChildrenWithText =
        hasChildElements &&
        Array.from(element.children).some(child =>
          child.textContent?.toLowerCase().includes('unsubscribe'),
        );

      if (!hasChildrenWithText) {
        lastUnsubscribeElement = element;
      }
    }
  }

  return lastUnsubscribeElement;
}
