import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="chat"
export default class extends Controller {
  static targets = [
    "messages",
    "message",
  ]

  messageTargetConnected(target) {
    target.scrollIntoView({
      behavior: 'smooth',
      block: 'end'
    })
  }
}
