import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["password", "confirmation", "icon", "hint"]

  connect() {
    this.tooShortMessageValue = this.tooShortMessageValue || 
      document.documentElement.getAttribute('data-password-too-short') || 
      'Пароль слишком короткий'
    this.matchMessageValue = this.matchMessageValue || 
      document.documentElement.getAttribute('data-passwords-match') || 
      'Пароли совпадают'
    this.noMatchMessageValue = this.noMatchMessageValue || 
      document.documentElement.getAttribute('data-passwords-no-match') || 
      'Пароли не совпадают'
  }

  validatePasswords() {
    const password = this.passwordTarget.value
    const confirmation = this.confirmationTarget.value
    const minLength = parseInt(this.passwordTarget.getAttribute('minlength')) || 6

    if (!password) {
      this.clearValidation()
      return
    }

    if (password.length < minLength) {
      this.showValidation('warning', this.tooShortMessageValue)
      return
    }

    if (!confirmation) {
      this.clearValidation()
      return
    }

    if (password === confirmation) {
      this.showValidation('success', this.matchMessageValue)
    } else {
      this.showValidation('danger', this.noMatchMessageValue)
    }
  }

  showValidation(type, message) {
    const icons = {
      success: 'bi-check-circle-fill',
      warning: 'bi-exclamation-circle-fill',
      danger: 'bi-x-circle-fill'
    }

    this.iconTarget.innerHTML = `
      <div class="d-flex align-items-center">
        <i class="bi ${icons[type]} text-${type} me-2"></i>
        <small class="text-${type}">${message}</small>
      </div>
    `
  }

  clearValidation() {
    this.iconTarget.innerHTML = ""
  }
}
