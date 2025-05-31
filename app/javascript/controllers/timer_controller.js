import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["countdown"]
  static values = {
    remainingTime: Number
  }

  connect() {
    if (this.hasCountdownTarget && this.remainingTimeValue > 0) {
      this.startTimer()
    }
  }

  disconnect() {
    if (this.timer) {
      clearInterval(this.timer)
    }
  }

  startTimer() {
    this.updateDisplay()
    this.timer = setInterval(() => {
      this.remainingTimeValue -= 1
      
      if (this.remainingTimeValue <= 0) {
        clearInterval(this.timer)
        this.handleTimeOut()
      } else {
        this.updateDisplay()
      }
    }, 1000)
  }

  updateDisplay() {
    const minutes = Math.floor(this.remainingTimeValue / 60)
    const seconds = this.remainingTimeValue % 60
    this.countdownTarget.textContent = `${minutes}:${seconds.toString().padStart(2, '0')}`
  }

  handleTimeOut() {
    const form = this.element.querySelector('form')
    if (form) {
      // Добавляем скрытое поле для индикации истечения времени
      const timeOutInput = document.createElement('input')
      timeOutInput.type = 'hidden'
      timeOutInput.name = 'time_out'
      timeOutInput.value = 'true'
      form.appendChild(timeOutInput)
      
      // Отправляем форму
      form.requestSubmit()
    } else {
      // Если форма не найдена, делаем редирект на страницу результатов
      const resultPath = this.element.dataset.resultPath
      if (resultPath) {
        window.location.href = resultPath
      }
    }
  }
} 
