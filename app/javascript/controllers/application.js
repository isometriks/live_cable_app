import { Application, Controller } from "@hotwired/stimulus"
import LiveCableBlessing from "@isometriks/live_cable/blessing"
import LiveController from "@isometriks/live_cable/controller"

Controller.blessings = [
  ...Controller.blessings,
  LiveCableBlessing,
]

const application = Application.start()

// Configure Stimulus development experience
application.debug = true
window.Stimulus   = application

application.register("live", LiveController)

export { application }
