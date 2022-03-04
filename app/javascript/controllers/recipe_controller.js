import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="recipe"
export default class extends Controller {
  static targets = [ "recipe" ]
  connect() {
    console.debug('recipe-controller connected');
  }
  fetchRecipe(event) {
    fetch(event.params.url)
      .then(r => r.text())
      .then(t => this.recipeTarget.innerHTML = t)
      .then(() => history.pushState({}, "", "?id=" + event.params.id)); 
  }
}
