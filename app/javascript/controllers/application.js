import { Application } from "@hotwired/stimulus"
import LiveController from "live_cable_controller"

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

application.register("live", LiveController)

export { application }
