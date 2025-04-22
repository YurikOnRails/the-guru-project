$(document).on('turbolinks:load', function() { 
  $('.form-inline-link').on('click', formInlineLinkHandler)

  var $errors = $('.resource-errors')

  if ($errors.length) {
    var resourceId = $errors.data('resourceId')
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

  $formInline.toggle()
  $testTitle.toggle()

  if ($formInline.is(':visible')) {
    $link.text('Cancel')
  } else {
    $link.text('Edit')
  }
}