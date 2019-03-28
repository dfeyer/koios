import './src/Styles.css';

import {Elm} from './src/Main.elm'
import localeFrench from './assets/locales/translation.fr.locale'
import learnings from './assets/activities.json'

const storageKey = "koios-store";
const viewer = JSON.parse(localStorage.getItem(storageKey));

const flags = {
  translations: {
    fr: localeFrench
  },
  learnings,
  viewer
};

const node = document.getElementById('main');

const app = Elm.Main.init({
  node,
  flags: JSON.stringify(flags)
});

app.ports.storeCache.subscribe(function (val) {
  if (val === null) {
    localStorage.removeItem(storageKey);
  } else {
    localStorage.setItem(storageKey, JSON.stringify(val));
  }
  // Report that the new session was stored succesfully.
  setTimeout(function () {
    app.ports.onStoreChange.send(val);
  }, 0);
});


// Whenever localStorage changes in another tab, report it if necessary.
window.addEventListener("viewer", function (event) {
  if (event.storageArea === localStorage && event.key === storageKey) {
    app.ports.onStoreChange.send(event.newValue);
  }
}, false);
