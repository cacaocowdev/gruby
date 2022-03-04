import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="stop"
export default class extends Controller {
  connect() {
    console.debug("Stop controller connected");
  }
  stopPropagation(event) {
    event.stopPropagation();
  }
  preventDefault(event) {
    event.preventDefault();
  }
}
