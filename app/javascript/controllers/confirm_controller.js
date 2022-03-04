import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="confirm"
export default class extends Controller {
  static values = { confirm: String }
  connect() {
  }
  confirm(event) {
    if (!confirm(this.confirmValue)) {
      event.preventDefault()
    }
  }
}
