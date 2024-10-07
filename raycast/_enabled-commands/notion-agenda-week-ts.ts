#!/usr/bin/env node

// Raycast Script Command Template
//
// Dependency: This script requires Nodejs.
// Install Node: https://nodejs.org/en/download/
//
// Required parameters:
// @raycast.schemaVersion 1
// @raycast.title Notion Agenda Planning Header Generator (TS)
// @raycast.mode compact
// @raycast.packageName Raycast Scripts
//
// Optional parameters:
// @raycast.icon 🤖
//
// Documentation:
// @raycast.description Enters in new week title
// @raycast.author Ed
// @raycast.authorURL An URL for one of your social medias

const { exec, spawn } = require('child_process');

const today = new Date();
const onejan = new Date(today.getFullYear(), 0, 1);
const weekNumber = Math.ceil(
  ((today - onejan) / 86400000 + onejan.getDay() + 1) / 7,
);

const monthName = today.toLocaleString('default', { month: 'long' });

const dayOfWeek = today.getDay(); // 0 = Sunday, 1 = Monday, ..., 6 = Saturday
const daysToSubtract = dayOfWeek === 0 ? 7 : dayOfWeek - 1;
const lastMonday = new Date(
  today.getTime() - daysToSubtract * 24 * 60 * 60 * 1000,
).getDate();

const nextSunday = new Date(
  today.getTime() + (7 - dayOfWeek) * 24 * 60 * 60 * 1000,
).getDate();

const textTocopy = `WEEK \`${weekNumber}\`: \`${monthName}\` \`${lastMonday}\` - \`${nextSunday}\``;

const message = `Copied to clipboard: ${textTocopy}`;
console.log(message);

// Function to copy data to clipboard
const pbcopy = data => {
  return new Promise(function (resolve, reject) {
    const child = spawn('pbcopy');

    child.on('error', function (err) {
      reject(err);
    });

    child.on('close', function (err) {
      resolve(data);
    });

    child.stdin.write(data);
    child.stdin.end();
  });
};

pbcopy(textTocopy);
