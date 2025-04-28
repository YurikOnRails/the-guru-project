// Флаг для отслеживания инициализации
let formInlineInitialized = false

document.addEventListener('turbo:load', initFormInline)
document.addEventListener('DOMContentLoaded', initFormInline)
// Сбрасываем флаг при навигации
document.addEventListener('turbo:before-render', () => {
  formInlineInitialized = false
})

function initFormInline() {
  // Если инлайн-формы уже инициализированы, не делаем ничего
  if (formInlineInitialized) {
    return
  }
  
  console.log('Initializing form inline functionality')
  const controls = $('.form-inline-link')
  console.log('Found form-inline-link controls:', controls.length)
  
  if (controls.length) {
    controls.on('click', formInlineLinkHandler)
    formInlineInitialized = true
    console.log('Initialized form-inline-link click handlers')
  }

  const errors = $('.resource-errors')
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

  // Атрибуты data-x в jQuery становятся camelCase: data('testId')
  // Но также проверим вариант с дефисом: data('test-id')
  let testId = $(this).data('testId')
  if (!testId) {
    testId = $(this).data('test-id')
    console.log('Using kebab-case data attribute, test-id:', testId)
  } else {
    console.log('Using camelCase data attribute, testId:', testId)
  }
  
  // Если всё ещё нет значения, попробуем получить атрибут напрямую
  if (!testId) {
    testId = $(this).attr('data-test-id')
    console.log('Using direct attribute access, data-test-id:', testId)
  }
  
  formInlineHandler(testId)
}

function formInlineHandler(testId) {
  console.log('Handling form inline for test ID:', testId)
  
  // Проверяем оба варианта атрибутов: camelCase и kebab-case
  let $link = $('.form-inline-link[data-test-id="' + testId + '"]')
  let $testTitle = $('.test-title[data-test-id="' + testId + '"]')
  let $formInline = $('.form-inline[data-test-id="' + testId + '"]')
  
  console.log('Elements found with kebab-case:',
    'link:', $link.length,
    'title:', $testTitle.length,
    'form:', $formInline.length
  )
  
  // Если не нашли с kebab-case, пробуем camelCase
  if (!$link.length) {
    $link = $('.form-inline-link[data-testId="' + testId + '"]')
    console.log('Link with camelCase:', $link.length)
  }
  
  if (!$testTitle.length) {
    $testTitle = $('.test-title[data-testId="' + testId + '"]')
    console.log('Title with camelCase:', $testTitle.length)
  }
  
  if (!$formInline.length) {
    $formInline = $('.form-inline[data-testId="' + testId + '"]')
    console.log('Form with camelCase:', $formInline.length)
  }

  if (!$link.length || !$testTitle.length || !$formInline.length) {
    console.error('One or more elements not found for test ID:', testId)
    // Выведем все form-inline-link на странице для отладки
    console.log('All form-inline-link elements:', $('.form-inline-link').length)
    $('.form-inline-link').each(function(i, el) {
      console.log(i, 'data-test-id:', $(el).attr('data-test-id'), 'data-testId:', $(el).data('testId'))
    })
    
    console.log('All test-title elements:', $('.test-title').length)
    $('.test-title').each(function(i, el) {
      console.log(i, 'data-test-id:', $(el).attr('data-test-id'), 'data-testId:', $(el).data('testId'))
    })
    
    console.log('All form-inline elements:', $('.form-inline').length)
    $('.form-inline').each(function(i, el) {
      console.log(i, 'data-test-id:', $(el).attr('data-test-id'), 'data-testId:', $(el).data('testId'))
    })
    
    return
  }

  $formInline.toggle()
  $testTitle.toggle()

  if ($formInline.is(':visible')) {
    console.log('Form is now visible, changing link text to Cancel')
    if (typeof Translations !== 'undefined') {
      $link.text(Translations.cancel)
    } else {
      console.error('Translations object is not defined!')
      $link.text('Cancel')
    }
  } else {
    console.log('Form is now hidden, changing link text to Edit')
    if (typeof Translations !== 'undefined') {
      $link.text(Translations.edit)
    } else {
      console.error('Translations object is not defined!')
      $link.text('Edit')
    }
  }
} 