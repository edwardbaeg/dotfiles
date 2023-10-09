// fade out "people also watched"
function fadeSection(label) {
  const spans = document.getElementsByTagName("span");
  let spanElement = null;
  for (let i = 0; i < spans.length; i++) {
    if (spans[i].textContent === label) {
      // Found the desired <span> element
      spanElement = spans[i];
      break;
    }
  }

  let parentDiv = null;
  let currentNode = spanElement.parentNode;

  while (currentNode !== document) {
    if (currentNode.tagName === "DIV" && currentNode.id === "dismissible") {
      parentDiv = currentNode;
      break;
    }

    currentNode = currentNode.parentNode;
  }

  if (parentDiv) {
    parentDiv.style.opacity = 0.1;
  } else {
    console.log('Parent div with id "dismissible" not found.');
  }
}

window.setTimeout(() => {
  fadeSection("People also watched");
  fadeSection("For you");
  fadeSection("Shorts people also watched"); // FIXME
}, 5000);
