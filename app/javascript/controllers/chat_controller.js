import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="chat"
//
// Driven entirely by server-dispatched events. The components call
// `dispatch_event` and LiveCable fires them as bubbling CustomEvents from the
// component root once the DOM has been morphed - so by the time these
// handlers run, the new message is already on the page.
export default class extends Controller {
  static targets = [
    "messages",
    "input",
  ]

  // chat:message-received - dispatched by ChatRoom's stream_from callback
  scrollToBottom() {
    this.messagesTarget.scrollTo({
      top: this.messagesTarget.scrollHeight,
      behavior: "smooth",
    })
  }

  // chat:sent - bubbles up from the nested ChatInput component
  focusInput() {
    if (this.hasInputTarget) {
      this.inputTarget.focus()
    }
  }
}
