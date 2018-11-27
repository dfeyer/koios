import { Elm } from './src/Main.elm'
import localeFrench from './assets/locales/translation.fr.locale'
import sections from './assets/sections.json'

Elm.Main.init({
    node: document.getElementById('main'),
    flags: {
      translations: {
        fr: localeFrench
      },
      sections: sections
    }
});
