import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["countdown"]
  static values = {
    remainingTime: Number
  }

  connect() {
    if (!this.hasRemainingTimeValue) return

    this.remainingSeconds = parseInt(this.remainingTimeValue)
    if (this.remainingSeconds <= 0) return

    this.startTimer()
  }

  disconnect() {
    if (this.timerInterval) {
      clearInterval(this.timerInterval)
    }
  }

  startTimer() {
    this.updateDisplay()
    this.timerInterval = setInterval(() => {
      this.remainingSeconds -= 1
      this.updateDisplay()

      if (this.remainingSeconds <= 0) {
        clearInterval(this.timerInterval)
        this.handleTimeout()
      }
    }, 1000)
  }

  updateDisplay() {
    const minutes = Math.floor(this.remainingSeconds / 60)
    const seconds = this.remainingSeconds % 60
    this.countdownTarget.textContent = `${minutes}:${seconds.toString().padStart(2, '0')}`
  }

  handleTimeout() {
    const form = document.querySelector('form')
    if (form) {
      // Добавляем скрытое поле для передачи информации о таймауте
      const timeoutInput = document.createElement('input')
      timeoutInput.type = 'hidden'
      timeoutInput.name = 'time_out'
      timeoutInput.value = 'true'
      form.appendChild(timeoutInput)
      
      // Отправляем форму
      form.submit()
    }
  }
} 
