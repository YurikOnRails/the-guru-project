// Флаг для отслеживания инициализации
let formInlineInitialized = false

// Инициализация с поддержкой Turbo и для первой загрузки
document.addEventListener('turbo:load', initFormInline)
document.addEventListener('DOMContentLoaded', initFormInline)

// Сбрасываем флаг при навигации
document.addEventListener('turbo:before-render', () => {
  formInlineInitialized = false
})

function initFormInline() {
  // Если инлайн-формы уже инициализированы, не делаем ничего
  if (formInlineInitialized) return
  
  // Получаем все кнопки редактирования
  const controls = document.querySelectorAll('.form-inline-link')
  
  if (controls.length) {
    // Добавляем обработчики клика
    controls.forEach(control => {
      control.addEventListener('click', formInlineLinkHandler)
    })
    formInlineInitialized = true
  }

  // Обработка ошибок, если они есть
  const errors = document.querySelector('.resource-errors')
  if (errors) {
    const resourceId = errors.dataset.resourceId
    formInlineHandler(resourceId)
  }
}

function formInlineLinkHandler(event) {
  event.preventDefault()

  const testId = this.dataset.testId
  
  // Определяем текущее состояние формы
  const formInline = document.querySelector(`.form-inline[data-test-id="${testId}"]`)
  const isEditMode = formInline && (formInline.style.display === 'block')
  
  if (isEditMode) {
    // Если уже в режиме редактирования, отправляем форму
    submitInlineForm(testId)
  } else {
    // Иначе показываем форму редактирования
    formInlineHandler(testId)
  }
}

function submitInlineForm(testId) {
  const form = document.querySelector(`.form-inline[data-test-id="${testId}"]`)
  
  if (form) {
    // Отправляем форму с обновленным названием
    Rails.fire(form, 'submit')
  } else {
    console.error('Form not found for test ID:', testId)
  }
}

function formInlineHandler(testId) {
  // Находим элементы для переключения
  const elements = {
    link: document.querySelector(`.form-inline-link[data-test-id="${testId}"]`),
    testTitle: document.querySelector(`.test-title[data-test-id="${testId}"]`),
    formInline: document.querySelector(`.form-inline[data-test-id="${testId}"]`)
  }
  
  const { link, testTitle, formInline } = elements
  
  if (!link || !testTitle || !formInline) {
    console.error('One or more elements not found for test ID:', testId)
    return
  }
  
  const titleInput = formInline.querySelector('input[type="text"]')
  if (!titleInput) {
    console.error('Title input not found for test ID:', testId)
    return
  }

  // Определяем текущее состояние отображения
  const isHidden = formInline.style.display === 'none' || formInline.style.display === ''
  
  // При первом открытии формы устанавливаем текущее значение заголовка в поле ввода
  if (isHidden) {
    titleInput.value = testTitle.textContent.trim()
  }

  // Переключаем отображение
  formInline.style.display = isHidden ? 'block' : 'none'
  testTitle.style.display = isHidden ? 'none' : 'block'
  
  // Устанавливаем фокус при отображении формы
  if (isHidden) {
    titleInput.focus()
  }
} 