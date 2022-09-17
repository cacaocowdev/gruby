import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="new-todo"
export default class extends Controller {
  static targets = ["form-container", "form", "preview"];
  connect() {
    console.debug("new-todo controller connected");
  }
  sendForm(e) {
    let url = e.target.action + '?inline=true';
    let method = e.target.method;
    let form = e.target;
    let data = new FormData(form);
    e.submitter.disabled = true;
    fetch(url, {
      method: method,
      body: data
    }).then(r => { if (r.status === 400) return r.text(); else if (r.ok) return "ok"; else throw "What the fuchs";})
      .then(p => { 
        if (p !== "ok") {
          this['form-containerTarget'].innerHTML = p;
         } else
          form.submit();
      })
      .finally(() => e.submitter.disabled = false);
    e.preventDefault();
  }
}