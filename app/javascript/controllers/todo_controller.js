import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="todo"
export default class extends Controller {
  static targets = [ "task" ]
  connect() {
  }
  fetchTask(event) {
    fetch(event.params.url)
      .then(r => r.text())
      .then(t => this.taskTarget.innerHTML = t)
      .then(() => history.pushState({}, "", "?id=" + event.params.id)); 
  }
}
