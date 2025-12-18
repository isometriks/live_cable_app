import { Application, Controller } from "@hotwired/stimulus"
import LiveCableBlessing from "live_cable_blessing"
import LiveController from "live_cable_controller"

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
