// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import * as bootstrap from "bootstrap"
import "jquery"
import "./utilities/sorting"
import "./utilities/form_inline"
import "./utilities/progress_bar_script"

// Делаем bootstrap глобальным
window.bootstrap = bootstrap;

// jQuery будет импортирован через importmap
