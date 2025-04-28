// Флаг для отслеживания инициализации
let formInlineInitialized = false

// Правильная инициализация с поддержкой Turbo
document.addEventListener('turbo:load', () => {
  console.log('Turbo load triggered, initializing form inline')
  // Проверяем, что jQuery доступен
  if (typeof jQuery === 'undefined') {
    console.error('jQuery is not loaded! Form inline cannot initialize.')
    return
  }
  
  initFormInline()
})

document.addEventListener('DOMContentLoaded', () => {
  console.log('DOM content loaded triggered, initializing form inline')
  // Проверяем, что jQuery доступен
  if (typeof jQuery === 'undefined') {
    console.error('jQuery is not loaded! Form inline cannot initialize.')
    return
  }
  
  initFormInline()
})

// Сбрасываем флаг при навигации
document.addEventListener('turbo:before-render', () => {
  formInlineInitialized = false
  console.log('Form inline initialization flag reset')
})

function initFormInline() {
  // Если инлайн-формы уже инициализированы, не делаем ничего
  if (formInlineInitialized) {
    console.log('Form inline already initialized, skipping')
    return
  }
  
  console.log('Initializing form inline functionality')
  
  // Используем документ как контекст для надёжного поиска элементов
  const controls = $(document).find('.form-inline-link')
  console.log('Found form-inline-link controls:', controls.length)
  
  if (controls.length) {
    // Удаляем существующие обработчики перед добавлением новых
    controls.off('click').on('click', formInlineLinkHandler)
    formInlineInitialized = true
    console.log('Initialized form-inline-link click handlers')
  }

  const errors = $(document).find('.resource-errors')
  console.log('Found resource-errors:', errors.length)

  if (errors.length) {
    const resourceId = errors.data('resourceId')
    console.log('Resource ID from errors:', resourceId)
    formInlineHandler(resourceId)
  }
}

function formInlineLinkHandler(event) {
  event.preventDefault()
  console.log('Form inline link clicked')

  const testId = $(this).data('testId')
  console.log('Test ID from link:', testId)
  
  formInlineHandler(testId)
}

function formInlineHandler(testId) {
  console.log('Handling form inline for test ID:', testId)
  
  // Используем более надёжный селектор для поиска элементов
  const $link = $(document).find(`.form-inline-link[data-test-id="${testId}"]`)
  const $testTitle = $(document).find(`.test-title[data-test-id="${testId}"]`)
  const $formInline = $(document).find(`.form-inline[data-test-id="${testId}"]`)
  
  console.log('Elements found:',
    'link:', $link.length,
    'title:', $testTitle.length,
    'form:', $formInline.length
  )

  if (!$link.length || !$testTitle.length || !$formInline.length) {
    console.error('One or more elements not found for test ID:', testId)
    console.log('Debug info:')
    console.log('All form-inline-link elements:', $(document).find('.form-inline-link').length)
    $(document).find('.form-inline-link').each(function(i, el) {
      console.log(i, 'data-test-id:', $(el).attr('data-test-id'))
    })
    
    return
  }

  // Переключаем отображение
  $formInline.toggle()
  $testTitle.toggle()

  if ($formInline.is(':visible')) {
    console.log('Form is now visible, changing link text to Cancel')
    if (typeof Translations !== 'undefined' && Translations.cancel) {
      $link.html('<i class="bi bi-x-circle me-1"></i>' + Translations.cancel)
    } else {
      $link.html('<i class="bi bi-x-circle me-1"></i>Отмена')
    }
  } else {
    console.log('Form is now hidden, changing link text to Edit')
    if (typeof Translations !== 'undefined' && Translations.edit) {
      $link.html('<i class="bi bi-pencil me-1"></i>' + Translations.edit)
    } else {
      $link.html('<i class="bi bi-pencil me-1"></i>Редактировать')
    }
  }
} 