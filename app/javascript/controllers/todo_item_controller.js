import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["text"]

  save() {
    this.liveCableAction('save', {
      text: this.textTarget.value,
    })
  }
}
