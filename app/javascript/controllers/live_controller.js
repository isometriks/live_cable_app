import { Controller } from "@hotwired/stimulus"
import consumer from "channels/consumer"
import morphdom from "morphdom"

export default class extends Controller {
  static values = {
    id: String,
    defaults: Object,
    sessionId: String,
    status: String,
    component: String,
  }

  #subscription

  connect() {
    this.#subscription = consumer.subscriptions.create({
      channel: "LiveChannel",
      component: this.componentValue,
      defaults: this.defaultsValue,
      _live_id: this.idValue,
      session_id: this.sessionIdValue,
    }, {
      received: (data) => {
        if (data['_id'] !== this.idValue) {
          return
        }

        if (data['_status']) {
          this.statusValue = data['_status']
        } else if (data['_refresh']) {
          console.log("Refreshing", data['_id'])
          morphdom(this.element, '<div>' + data['_refresh'] + '</div>', {
            childrenOnly: true,
          })
        }
      },
    })
  }

  call({ params }) {
    this.#subscription.send({
      _action: params["action"],
      _live_id: this.idValue,
      params: new URLSearchParams(params).toString(),
    })
  }

  reactive({ target }) {
    this.#subscription.send({
      action: 'reactive',
      name: target.name,
      value: target.value,
      _live_id: this.idValue,
    })
  }

  form({ currentTarget, params: { action } }) {
    const formData = new FormData(currentTarget)

    this.#subscription.send({
      _action: action,
      _live_id: this.idValue,
      params: new URLSearchParams(formData).toString(),
    })
  }
}
