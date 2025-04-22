import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["password", "confirmation", "icon"]

  validatePasswords() {
    const password = this.passwordTarget.value
    const confirmation = this.confirmationTarget.value

    if (!confirmation) {
      this.iconTarget.innerHTML = ""
      return
    }

    if (password === confirmation) {
      this.iconTarget.innerHTML = '<i class="bi bi-check-circle-fill text-success"></i>'
    } else {
      this.iconTarget.innerHTML = '<i class="bi bi-x-circle-fill text-danger"></i>'
    }
  }
}
