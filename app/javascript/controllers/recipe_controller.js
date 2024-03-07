import { Controller } from "@hotwired/stimulus"
import * as bootstrap from "bootstrap"

// Connects to data-controller="recipe"
export default class extends Controller {
  static targets = [ 'recipe', 'dialog' ]
  connect() {
    console.debug('recipe-controller connected');
  }
  fetchRecipe(event) {
    fetch(event.params.url)
      .then(r => r.text())
      .then(t => this.recipeTarget.innerHTML = t)
      .then(() => history.pushState({}, "", "?id=" + event.params.id)); 
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
      .then(() => modal.show());

    event.preventDefault();
    event.stopPropagation();
  }
}
