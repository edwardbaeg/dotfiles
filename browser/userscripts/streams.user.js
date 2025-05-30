// ==UserScript==
// @name         Stream Highlighter
// @namespace    http://tampermonkey.net/
// @version      2024-04-11
// @description  try to take over the world!
// @author       You
// @match        https://methstreams.com/*
// @icon         https://www.google.com/s2/favicons?sz=64&domain=google.com
// @grant        none
// ==/UserScript==

(function () {
  'use strict';

  const navLinkNodes = document.querySelectorAll('ul.navbar-nav a');
  navLinkNodes.forEach(node => {
    if (node.innerText.includes('NBA') || node.innerText.includes('NFL')) {
      node.style.border = '1px solid red';
    }
  });

  const linkNodes = document.querySelectorAll('a.btn');
  linkNodes.forEach(node => {
    if (
      node.innerText.includes('Mavericks') ||
      node.innerText.includes('Dallas') ||
      node.innerText.includes('Cowboys') ||
      node.innerText.includes('REDZONE') ||
      // on index page
      node.innerText.includes('NBA Schedule') ||
      node.innerText.includes('NFL Schedule')
    ) {
      node.style.border = '1px solid red';
    }
  });

  // const nodes = document.querySelectorAll('h4.media-heading');
  // nodes.forEach(node => {
  //   if (
  //     node.innerText.includes('Mavericks') ||
  //     node.innerText.includes('Dallas') ||
  //     node.innerText.includes('Cowboys')
  //   ) {
  //     node.style.color = 'red';
  //   }
  // });
})();
