import { Controller } from "@hotwired/stimulus"
import * as bootstrap from "bootstrap"

// Connects to data-controller="transaction"
export default class extends Controller {
  static targets = [ 'dialog', 'title' ];

  connect() {
    console.debug("Transaction controller conntected")
  }
  loadForm(event) {
    let url = event.target.tagName.toUpperCase() === "A"? event.target.href : event.target.parentElement.href;
    if (url.includes('?'))
      url += "&inline";
    else
      url += "?inline";

    let modal = new bootstrap.Modal(document.getElementById('transaction-modal'));
    
    fetch(url)
    .then(r => r.text())
    .then(r => this.dialogTarget.innerHTML = r)
    .then(() => this.titleTarget.innerHTML = event.params.title)
    .then(() => modal.show());

    event.preventDefault();
  }
}
