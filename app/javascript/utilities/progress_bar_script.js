document.addEventListener('turbo:load', initProgressBar)
document.addEventListener('DOMContentLoaded', initProgressBar)

let progressBarInitialized = false

// Сбрасываем флаг при навигации
document.addEventListener('turbo:before-render', () => {
  progressBarInitialized = false
})

function initProgressBar() {
  if (progressBarInitialized) {
    return
  }

  const progressContainer = document.getElementById('progress-container')
  
  if (progressContainer) {
    // Получаем данные из data-атрибутов
    const totalQuestions = parseInt(progressContainer.dataset.totalQuestions)
    const currentQuestion = parseInt(progressContainer.dataset.currentQuestion)
    
    // Получаем элементы прогресс-бара
    const progressBar = document.getElementById('progress-bar')
    const progressPercent = document.getElementById('progress-percent')
    
    if (progressBar && progressPercent && totalQuestions > 0) {
      // Рассчитываем процент выполнения
      const progressValue = (currentQuestion / totalQuestions) * 100
      
      // Анимируем прогресс-бар
      animateProgressBar(progressBar, progressValue)
      
      // Устанавливаем флаг инициализации
      progressBarInitialized = true
    }
  }
}

function animateProgressBar(progressBar, targetValue) {
  // Получаем текущее значение прогресс-бара
  let currentValue = 0
  
  // Создаем интервал для анимации
  const animationInterval = setInterval(() => {
    // Увеличиваем текущее значение
    currentValue += 1
    
    // Обновляем ширину прогресс-бара
    progressBar.style.width = currentValue + '%'
    progressBar.setAttribute('aria-valuenow', currentValue)
    
    // Если достигли целевого значения, останавливаем анимацию
    if (currentValue >= targetValue) {
      clearInterval(animationInterval)
    }
  }, 20)
} 