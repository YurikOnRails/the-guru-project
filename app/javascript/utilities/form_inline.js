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
  
  const controls = $('.form-inline-link')
  
  if (controls.length) {
    controls.on('click', formInlineLinkHandler)
    formInlineInitialized = true
  }

  const errors = $('.resource-errors')

  if (errors.length) {
    const resourceId = errors.data('resourceId')
    formInlineHandler(resourceId)
  }
}

function formInlineLinkHandler(event) {
  event.preventDefault()

  const testId = $(this).data('testId')
  formInlineHandler(testId)
}

function formInlineHandler(testId) {
  const $link = $('.form-inline-link[data-test-id="' + testId + '"]')
  const $testTitle = $('.test-title[data-test-id="' + testId + '"]')
  const $formInline = $('.form-inline[data-test-id="' + testId + '"]')

  if (!$link.length || !$testTitle.length || !$formInline.length) {
    console.error('One or more elements not found for test ID:', testId)
    return
  }

  $formInline.toggle()
  $testTitle.toggle()

  if ($formInline.is(':visible')) {
    $link.text(Translations.cancel)
  } else {
    $link.text(Translations.edit)
  }
} 