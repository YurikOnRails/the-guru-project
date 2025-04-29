// Флаг для отслеживания инициализации
let formInlineInitialized = false

// Правильная инициализация с поддержкой Turbo
document.addEventListener('turbo:load', () => {
  console.log('Turbo load triggered, initializing form inline')
  initFormInline()
})

document.addEventListener('DOMContentLoaded', () => {
  console.log('DOM content loaded triggered, initializing form inline')
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
  
  // Получаем все кнопки редактирования
  const controls = document.querySelectorAll('.form-inline-link')
  console.log('Found form-inline-link controls:', controls.length)
  
  if (controls.length) {
    // Добавляем обработчики клика
    controls.forEach(control => {
      control.addEventListener('click', formInlineLinkHandler)
    })
    formInlineInitialized = true
    console.log('Initialized form-inline-link click handlers')
  }

  // Обработка ошибок, если они есть
  const errors = document.querySelector('.resource-errors')
  if (errors) {
    const resourceId = errors.dataset.resourceId
    console.log('Resource ID from errors:', resourceId)
    formInlineHandler(resourceId)
  }
}

function formInlineLinkHandler(event) {
  event.preventDefault()
  console.log('Form inline link clicked')

  const testId = this.dataset.testId
  console.log('Test ID from link:', testId)
  
  formInlineHandler(testId)
}

function formInlineHandler(testId) {
  console.log('Handling form inline for test ID:', testId)
  
  // Находим элементы для переключения
  const link = document.querySelector(`.form-inline-link[data-test-id="${testId}"]`)
  const testTitle = document.querySelector(`.test-title[data-test-id="${testId}"]`)
  const formInline = document.querySelector(`.form-inline[data-test-id="${testId}"]`)
  
  console.log('Elements found:',
    'link:', link ? 'yes' : 'no',
    'title:', testTitle ? 'yes' : 'no',
    'form:', formInline ? 'yes' : 'no'
  )

  if (!link || !testTitle || !formInline) {
    console.error('One or more elements not found for test ID:', testId)
    return
  }

  // Переключаем отображение
  formInline.style.display = formInline.style.display === 'none' ? 'block' : 'none'
  testTitle.style.display = testTitle.style.display === 'none' ? 'block' : 'none'

  if (formInline.style.display !== 'none') {
    console.log('Form is now visible, changing link text to Cancel')
    if (typeof Translations !== 'undefined' && Translations.cancel) {
      link.innerHTML = '<i class="bi bi-x-circle me-1"></i>' + Translations.cancel
    } else {
      link.innerHTML = '<i class="bi bi-x-circle me-1"></i>Отмена'
    }
  } else {
    console.log('Form is now hidden, changing link text to Edit')
    if (typeof Translations !== 'undefined' && Translations.edit) {
      link.innerHTML = '<i class="bi bi-pencil me-1"></i>' + Translations.edit
    } else {
      link.innerHTML = '<i class="bi bi-pencil me-1"></i>Редактировать'
    }
  }
} 