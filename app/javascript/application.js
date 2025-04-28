// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import * as bootstrap from "bootstrap"
// jQuery импортируется через тег <script> в макете
import "./utilities/sorting"
import "./utilities/form_inline"
// Импорт JS-кода для прогресс-бара
import "./utilities/progress_bar_script"
import "jquery"

// Делаем bootstrap глобальным
window.bootstrap = bootstrap;

// Проверим загрузку
console.log("Application initialized, jQuery available:", (typeof jQuery !== 'undefined'));
