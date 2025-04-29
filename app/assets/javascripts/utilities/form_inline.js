document.addEventListener('turbo:load', function() { 
  document.querySelectorAll('.form-inline-link').forEach(link => {
    link.addEventListener('click', formInlineLinkHandler)
  })

  const errors = document.querySelector('.resource-errors')

  if (errors) {
    const resourceId = errors.dataset.resourceId
    formInlineHandler(resourceId)
  }
})

// Код для обработки события DOMContentLoaded для первой загрузки
document.addEventListener('DOMContentLoaded', function() {
  document.querySelectorAll('.form-inline-link').forEach(link => {
    link.addEventListener('click', formInlineLinkHandler)
  })

  const errors = document.querySelector('.resource-errors')

  if (errors) {
    const resourceId = errors.dataset.resourceId
    formInlineHandler(resourceId)
  }
})

function formInlineLinkHandler(event) {
  event.preventDefault()

  const testId = this.dataset.testId
  formInlineHandler(testId)
}

function formInlineHandler(testId) {
  const link = document.querySelector(`.form-inline-link[data-test-id="${testId}"]`)
  const testTitle = document.querySelector(`.test-title[data-test-id="${testId}"]`)
  const formInline = document.querySelector(`.form-inline[data-test-id="${testId}"]`)

  if (!link || !testTitle || !formInline) {
    console.error('One or more elements not found for test ID:', testId)
    return
  }

  // Используем toggle для переключения видимости
  formInline.style.display = formInline.style.display === 'none' ? 'block' : 'none'
  testTitle.style.display = testTitle.style.display === 'none' ? 'block' : 'none'

  if (formInline.style.display !== 'none') {
    link.textContent = Translations.cancel
  } else {
    link.textContent = Translations.edit
  }
} 