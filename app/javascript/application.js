// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import * as bootstrap from "bootstrap"
import "jquery"
import "./utilities/sorting"
import "./utilities/form_inline"
// Импорт JS-кода для прогресс-бара
import "./utilities/progress_bar_script"

window.bootstrap = bootstrap;
window.jQuery = window.$ = jQuery;
