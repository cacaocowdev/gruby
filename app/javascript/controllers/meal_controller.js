import { Controller } from "@hotwired/stimulus"
import * as bootstrap from "bootstrap"

// Connects to data-controller="meal"
export default class extends Controller {
  static targets = [ 'dialog', 'title' ];

  connect() {
    console.debug("Meal controller conntected")
  }
  loadForm(event) {
    let url = event.target.parentElement.href;
    if (url.includes('?'))
      url += "&inline";
    else
      url += "?inline";
    
    let modal = new bootstrap.Modal(document.getElementById('meal-dialog'));

    fetch(url)
      .then(r => r.text())
      .then(r => this.dialogTarget.innerHTML = r)
      .then(r => this.titleTarget.innerHTML = event.params.title)
      .then(() => modal.show());

    event.preventDefault();
  }
  
}
