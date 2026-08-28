import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="demo"
//
// Handles the events Live::LoadingDemo dispatches from the server. Nothing
// here is LiveCable-specific - they arrive as ordinary bubbling CustomEvents
// from the component root, after the DOM has been morphed.
export default class extends Controller {
  static targets = ["form", "log"]

  // demo:note-added
  noteAdded(event) {
    this.log(event)

    // The note input isn't reactive, so the server can't clear it - but the
    // event tells us the write succeeded
    this.formTarget.reset()

    // The morph has already happened, so the new note is on the page
    const note = document.getElementById(`note-${event.detail.id}`)

    if (note) {
      note.classList.add("live-flash")
      note.scrollIntoView({ behavior: "smooth", block: "nearest" })
    }
  }

  // demo:pinged, and anything else worth showing in the log
  log(event) {
    if (!this.hasLogTarget) return

    this.#placeholder?.remove()

    const entry = document.createElement("li")
    entry.textContent = `${new Date().toLocaleTimeString()} — ${event.type} ${JSON.stringify(event.detail ?? {})}`

    this.logTarget.prepend(entry)
  }

  get #placeholder() {
    return this.logTarget.querySelector("[data-placeholder]")
  }
}
