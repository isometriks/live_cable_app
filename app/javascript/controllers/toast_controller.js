import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="toast"
//
// Renders toasts pushed from a LiveCable component with:
//
//   dispatch_event('toast:show', message: 'Saved', level: 'success', window: true)
//
// `window: true` dispatches on window instead of the component root, so this
// container can live in the layout, outside of any component tree.
export default class extends Controller {
  static values = { duration: { type: Number, default: 3500 } }

  show({ detail }) {
    const { message, level = "info" } = detail ?? {}

    if (!message) return

    const alert = document.createElement("div")
    // The container is pointer-events-none so it never blocks clicks when empty
    alert.className = `alert alert-${level} shadow-lg pointer-events-auto`
    alert.textContent = message

    this.element.appendChild(alert)

    setTimeout(() => alert.remove(), this.durationValue)
  }
}
