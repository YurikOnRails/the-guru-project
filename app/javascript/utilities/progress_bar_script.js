// Обработчики событий для инициализации прогресс-бара
document.addEventListener('turbo:load', initProgressBar)
document.addEventListener('DOMContentLoaded', initProgressBar)

// Флаг инициализации
let progressBarInitialized = false

// Сбрасываем флаг при навигации
document.addEventListener('turbo:before-render', () => {
  progressBarInitialized = false
})

/**
 * Инициализирует прогресс-бар, если он присутствует на странице
 */
function initProgressBar() {
  if (progressBarInitialized) return

  const progressContainer = document.getElementById('progress-container')
  if (!progressContainer) return
  
  // Получаем данные и элементы
  const elements = getProgressElements(progressContainer)
  
  if (!elements) return
  
  const { progressBar, progressPercent, totalQuestions, currentQuestion } = elements
  
  // Рассчитываем и устанавливаем прогресс
  if (totalQuestions > 0) {
    const progressValue = Math.round((currentQuestion / totalQuestions) * 100)
    
    // Анимируем прогресс-бар
    animateProgressBar(progressBar, progressValue)
    
    // Обновляем текстовое представление (если необходимо)
    if (progressPercent) {
      progressPercent.textContent = `${progressValue}%`
    }
    
    // Устанавливаем флаг инициализации
    progressBarInitialized = true
  }
}

/**
 * Получает необходимые элементы и значения для прогресс-бара
 * @param {HTMLElement} container - Контейнер прогресс-бара
 * @returns {Object|null} - Объект с элементами и значениями или null
 */
function getProgressElements(container) {
  // Получаем данные из data-атрибутов
  const totalQuestions = parseInt(container.dataset.totalQuestions, 10)
  const currentQuestion = parseInt(container.dataset.currentQuestion, 10)
  
  // Получаем элементы прогресс-бара
  const progressBar = document.getElementById('progress-bar')
  const progressPercent = document.getElementById('progress-percent')
  
  if (!progressBar || isNaN(totalQuestions) || isNaN(currentQuestion)) {
    return null
  }
  
  return { progressBar, progressPercent, totalQuestions, currentQuestion }
}

/**
 * Анимирует прогресс-бар до целевого значения
 * @param {HTMLElement} progressBar - Элемент прогресс-бара
 * @param {number} targetValue - Целевое значение в процентах
 */
function animateProgressBar(progressBar, targetValue) {
  // Ограничиваем targetValue диапазоном 0-100
  const safeTarget = Math.min(100, Math.max(0, targetValue))
  
  // Получаем текущее значение прогресс-бара
  let currentValue = 0
  
  // Используем requestAnimationFrame для более плавной анимации
  const step = () => {
    // Увеличиваем текущее значение (более быстрая анимация при большем расстоянии)
    const increment = Math.max(1, Math.ceil((safeTarget - currentValue) / 10))
    currentValue = Math.min(safeTarget, currentValue + increment)
    
    // Обновляем ширину прогресс-бара
    updateProgressBar(progressBar, currentValue)
    
    // Если не достигли целевого значения, продолжаем анимацию
    if (currentValue < safeTarget) {
      requestAnimationFrame(step)
    }
  }
  
  // Запускаем анимацию
  requestAnimationFrame(step)
}

/**
 * Обновляет визуальное представление прогресс-бара
 * @param {HTMLElement} progressBar - Элемент прогресс-бара
 * @param {number} value - Значение в процентах
 */
function updateProgressBar(progressBar, value) {
  progressBar.style.width = value + '%'
  progressBar.setAttribute('aria-valuenow', value)
} 