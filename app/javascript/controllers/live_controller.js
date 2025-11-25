import { Controller } from "@hotwired/stimulus"
import consumer from "channels/consumer"
import morphdom from "morphdom"

export default class extends Controller {
  static values = {
    defaults: Object,
    status: String,
    component: String,
  }

  #subscription

  connect() {
    this.#subscription = consumer.subscriptions.create({
      channel: "LiveChannel",
      component: this.componentValue,
      defaults: this.defaultsValue,
    }, {
      received: (data) => {
        if (data['_status']) {
          this.statusValue = data['_status']
        } else if (data['_refresh']) {
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
      params: new URLSearchParams(params).toString(),
      _csrf_token: this.#csrfToken,
    })
  }

  reactive({ target }) {
    this.#subscription.send({
      action: 'reactive',
      name: target.name,
      value: target.value,
      _csrf_token: this.#csrfToken,
    })
  }

  form({ currentTarget, params: { action } }) {
    const formData = new FormData(currentTarget)

    this.#subscription.send({
      _action: action,
      params: new URLSearchParams(formData).toString(),
      _csrf_token: this.#csrfToken,
    })
  }

  get #csrfToken() {
    return document.querySelector("meta[name='csrf-token']")?.getAttribute("content")
  }
}
