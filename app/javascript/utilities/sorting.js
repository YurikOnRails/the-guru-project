// Флаг для отслеживания инициализации
let sortingInitialized = false

document.addEventListener('turbo:load', initSort)
document.addEventListener('DOMContentLoaded', initSort)
// Сбрасываем флаг при навигации
document.addEventListener('turbo:before-render', () => {
  sortingInitialized = false
})

function initSort() {
  // Если сортировка уже инициализирована, не делаем ничего
  if (sortingInitialized) {
    return
  }
  
  const control = document.querySelector('.sort-by-title')
  if (control) {
    control.addEventListener('click', sortRowsByTitle)
    // Устанавливаем флаг, что сортировка инициализирована
    sortingInitialized = true
  }
}

function sortRowsByTitle() {
  const table = this.closest('table')
  if (!table) return
  
  const tbody = table.querySelector('tbody')
  if (!tbody) return

  const rows = Array.from(tbody.querySelectorAll('tr'))
  
  const sortedRows = rows.sort((row1, row2) => {
    const title1 = row1.querySelector('td')?.textContent?.trim() || ''
    const title2 = row2.querySelector('td')?.textContent?.trim() || ''
    
    if (this.querySelector('.octicon-arrow-up').classList.contains('hide')) {
      return title1.localeCompare(title2)
    } else {
      return title2.localeCompare(title1)
    }
  })

  // Переключаем стрелки
  const arrowUp = this.querySelector('.octicon-arrow-up')
  const arrowDown = this.querySelector('.octicon-arrow-down')
  
  if (arrowUp.classList.contains('hide')) {
    arrowUp.classList.remove('hide')
    arrowDown.classList.add('hide')
  } else {
    arrowDown.classList.remove('hide')
    arrowUp.classList.add('hide')
  }

  // Очищаем и заполняем tbody
  tbody.innerHTML = ''
  sortedRows.forEach(row => tbody.appendChild(row))
}
