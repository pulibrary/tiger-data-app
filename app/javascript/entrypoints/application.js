// import 'bootstrap/js/src/alert'
// import 'bootstrap/js/src/button'
// import 'bootstrap/js/src/carousel'
import 'bootstrap/js/src/collapse';
import 'bootstrap/js/src/dropdown';
// import 'bootstrap/js/src/modal'
// import 'bootstrap/js/src/popover'
import 'bootstrap/js/src/scrollspy';
// import 'bootstrap/js/src/tab'
// import 'bootstrap/js/src/toast'
// import 'bootstrap/js/src/tooltip'

import * as bootstrap from 'bootstrap';

window.bootstrap = bootstrap;

function initPage() {
  $('#test-jquery').click((event) => {
    $(event.target).html('jQuery works!');
  });
}

window.addEventListener('load', () => initPage());
window.addEventListener('turbo:render', () => initPage());
