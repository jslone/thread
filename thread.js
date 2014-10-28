var words;
var textElem = document.getElementById("text");

function setupText() {
  words = textElem.innerHTML.split("</p>");
  textElem.innerHTML = "";
}

function addword() {
  if(words.length > 0)
    textElem.innerHTML += words.shift() + "</p>";
}
