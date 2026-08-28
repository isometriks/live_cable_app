# LiveCable Sample App

A demo Rails application showcasing [LiveCable](https://github.com/nicholaides/live_cable) — a gem for building real-time, server-rendered interactive components in Rails over ActionCable.

## Examples

| Example | Route | Features demonstrated |
|---------|-------|----------------------|
| **Todo List** | `/todo` | Shared state, reactive inputs, filtering, compound components |
| **Chat Room** | `/chat` | ActionCable streaming, broadcasting, server events (`dispatch_event`) |
| **Dialog Form** | `/dialog` | Compound components, confirmation dialogs, template states |
| **Team Builder** | `/team_builder` | Shared state across instances, form handling, model validations |
| **E-Commerce Shop** | `/shop` | Shared cart state, pagination, `live-disable-with` checkout, toast events |
| **Loading & Events** | `/loading` | `live-loading`, `live-disable-with`, `dispatch_event`, adjustable latency |

## Setup

### Prerequisites

- Ruby 3.4+
- SQLite3

### Installation

```bash
git clone <repo-url>
cd live_cable_app

bundle install
bin/rails db:setup

bin/dev
```

Visit [http://localhost:3000](http://localhost:3000) to see the examples index.

## How it works

LiveCable components live in `app/live/` and their templates in `app/views/live/`. Each component is a Ruby class that inherits from `LiveCable::Component` and declares:

- **`reactive`** — state that triggers re-renders when changed
- **`shared`** — state shared across sibling components
- **`actions`** — methods callable from the client via `live-action` attributes
- **`compound`** — enables multiple template states (e.g. `:component`, `:edit`, `:submitted`)
- **`dispatch_event`** — queues a DOM event for the client, fired after the morph

Templates use standard ERB with LiveCable-specific attributes like `live-form`, `live-action`, `live-reactive`, `live-debounce`, and `live-disable-with`.

### Loading states

While a message is in flight, LiveCable adds a `live-loading` attribute to the component root and to the element that triggered it. `app/assets/stylesheets/app.css` styles those states — dimmed buttons, a `.live-spinner` that only shows while the component is busy, and a `.live-dim` region. Buttons marked `live-disable-with` are disabled for the round trip, with an optional label swap:

```erb
<button live-action="checkout" live-disable-with="Processing payment…">Checkout</button>
```

Note the label swap replaces `textContent`, so use the bare attribute on buttons containing icons (see the chat send button).

### Server events

Components push DOM events to the client with `dispatch_event`. They arrive as bubbling `CustomEvent`s from the component root *after* the DOM has been morphed, so plain Stimulus `data-action` handles them:

```ruby
dispatch_event("chat:message-received", id: data["id"])          # component root
dispatch_event("toast:show", message: "Saved", window: true)     # window
```

`app/javascript/controllers/toast_controller.js` in the layout handles the `window: true` toasts; `chat_controller.js` and `demo_controller.js` handle the component-scoped ones.

## Project structure

```
app/
  live/                         # LiveCable components
    chat/chat_room.rb           # Chat room with streaming
    chat/chat_input.rb          # Chat message input
    dialog/dialog.rb            # Reusable confirmation dialog
    dialog/form.rb              # Form with dialog integration
    loading_demo.rb             # Loading states & server events playground
    shop/cart.rb                # Shopping cart with checkout loading state
    shop/product_grid.rb        # Product listing with pagination
    team_builder.rb             # Team builder with shared state
    todo/input.rb               # Todo input form
    todo/item.rb                # Individual todo item
    todo/list.rb                # Todo list with filtering
  views/live/                   # Component templates (ERB)
```

## Note

This app uses [Faker](https://github.com/faker-ruby/faker) to generate demo users on each WebSocket connection, so authentication is not required to explore the examples. See `app/channels/application_cable/connection.rb` for details.
