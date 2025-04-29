# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"
pin "bootstrap", to: "https://ga.jspm.io/npm:bootstrap@5.3.2/dist/js/bootstrap.esm.js"
pin "@popperjs/core", to: "https://ga.jspm.io/npm:@popperjs/core@2.11.8/lib/index.js"

# Индивидуальное указание JavaScript-файлов
pin "utilities/sorting", to: "utilities/sorting.js"
pin "utilities/form_inline", to: "utilities/form_inline.js"
pin "utilities/progress_bar_script", to: "utilities/progress_bar_script.js"

# jQuery загружается через тег <script> в макете приложения
# Удаляем jQuery, так как перешли на vanilla JavaScript
# pin "jquery", to: "https://cdn.jsdelivr.net/npm/jquery@3.7.1/dist/jquery.min.js"
