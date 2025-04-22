document.addEventListener('turbo:load', initSort)
document.addEventListener('turbo:render', initSort)

function initSort() {
  const control = document.querySelector('.sort-by-title')
  if (control) {
    console.log('Sort control found')
    control.addEventListener('click', sortRowsByTitle)
  } else {
    console.log('Sort control not found')
  }
}

function sortRowsByTitle() {
  console.log('Sort clicked')
  const table = this.closest('table')
  if (!table) {
    console.log('Table not found')
    return
  }

  const tbody = table.querySelector('tbody')
  if (!tbody) {
    console.log('Tbody not found')
    return
  }

  const rows = Array.from(tbody.querySelectorAll('tr'))
  console.log(`Found ${rows.length} rows to sort`)
  
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
