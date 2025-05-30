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
        this.submitForm()
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

  submitForm() {
    const form = this.element.closest('form')
    if (form) {
      form.requestSubmit()
    }
  }
} 
