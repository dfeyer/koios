import './src/Styles.css';

import { Elm } from './src/Main.elm'
import localeFrench from './assets/locales/translation.fr.locale'
import activities from './assets/activities.json'

Elm.Main.init({
    node: document.getElementById('main'),
    flags: {
      translations: {
        fr: localeFrench
      },
      activities: activities
    }
});
