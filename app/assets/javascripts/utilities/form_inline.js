document.addEventListener('turbolinks:load', function() { 
  $('.form-inline-link').on('click', formInlineLinkHandler)

  var errors = $('.resource-errors')

  if (errors.length) {
    var resourceId = errors.data('resourceId')
    formInlineHandler(resourceId)
  }
})

function formInlineLinkHandler(event) {
  event.preventDefault()

  var testId = $(this).data('testId')
  formInlineHandler(testId)
}

function formInlineHandler(testId) {
  var $link = $('.form-inline-link[data-test-id="' + testId + '"]')
  var $testTitle = $('.test-title[data-test-id="' + testId + '"]')
  var $formInline = $('.form-inline[data-test-id="' + testId + '"]')

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