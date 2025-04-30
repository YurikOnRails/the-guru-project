// Флаг для отслеживания инициализации
let sortingInitialized = false

// Инициализация обработчиков
document.addEventListener('turbo:load', initSort)
document.addEventListener('DOMContentLoaded', initSort)

// Сбрасываем флаг при навигации
document.addEventListener('turbo:before-render', () => {
  sortingInitialized = false
})

function initSort() {
  // Если сортировка уже инициализирована, не делаем ничего
  if (sortingInitialized) return
  
  const control = document.querySelector('.sort-by-title')
  if (control) {
    control.addEventListener('click', sortRowsByTitle)
    sortingInitialized = true
  }
}

function sortRowsByTitle() {
  const table = this.closest('table')
  const tbody = table?.querySelector('tbody')
  
  if (!tbody) return
  
  // Получаем все строки таблицы
  const rows = Array.from(tbody.querySelectorAll('tr'))
  
  // Определяем текущее направление сортировки
  const arrowUp = this.querySelector('.octicon-arrow-up')
  const arrowDown = this.querySelector('.octicon-arrow-down')
  const isAscending = arrowUp.classList.contains('hide')
  
  // Сортируем строки
  const sortedRows = sortRows(rows, isAscending)
  
  // Переключаем стрелки для визуальной индикации
  toggleSortDirection(arrowUp, arrowDown)
  
  // Обновляем содержимое таблицы
  updateTable(tbody, sortedRows)
}

// Вспомогательная функция для сортировки строк
function sortRows(rows, isAscending) {
  return rows.sort((row1, row2) => {
    const title1 = row1.querySelector('td')?.textContent?.trim() || ''
    const title2 = row2.querySelector('td')?.textContent?.trim() || ''
    
    // Сортировка в зависимости от направления
    return isAscending 
      ? title1.localeCompare(title2)
      : title2.localeCompare(title1)
  })
}

// Вспомогательная функция для переключения направления сортировки
function toggleSortDirection(arrowUp, arrowDown) {
  arrowUp.classList.toggle('hide')
  arrowDown.classList.toggle('hide')
}

// Вспомогательная функция для обновления таблицы
function updateTable(tbody, sortedRows) {
  tbody.innerHTML = ''
  sortedRows.forEach(row => tbody.appendChild(row))
}
