# LiveCable Sample App

A demo Rails application showcasing [LiveCable](https://github.com/nicholaides/live_cable) — a gem for building real-time, server-rendered interactive components in Rails over ActionCable.

## Examples

| Example | Route | Features demonstrated |
|---------|-------|----------------------|
| **Todo List** | `/todo` | Shared state, reactive inputs, filtering, compound components |
| **Chat Room** | `/chat` | ActionCable streaming, broadcasting, multi-user real-time updates |
| **Dialog Form** | `/dialog` | Compound components, confirmation dialogs, template states |
| **Team Builder** | `/team_builder` | Shared state across instances, form handling, model validations |
| **E-Commerce Shop** | `/shop` | Shared cart state, pagination, computed properties |

## Setup

### Prerequisites

- Ruby 3.4+
- SQLite3
- Redis (for ActionCable in development)

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

Templates use standard ERB with LiveCable-specific attributes like `live-form`, `live-action`, `live-reactive`, and `live-debounce`.

## Project structure

```
app/
  live/                         # LiveCable components
    chat/chat_room.rb           # Chat room with streaming
    chat/chat_input.rb          # Chat message input
    dialog/dialog.rb            # Reusable confirmation dialog
    dialog/form.rb              # Form with dialog integration
    shop/cart.rb                # Shopping cart
    shop/product_grid.rb        # Product listing with pagination
    team_builder.rb             # Team builder with shared state
    todo/input.rb               # Todo input form
    todo/item.rb                # Individual todo item
    todo/list.rb                # Todo list with filtering
  views/live/                   # Component templates (ERB)
```

## Note

This app uses [Faker](https://github.com/faker-ruby/faker) to generate demo users on each WebSocket connection, so authentication is not required to explore the examples. See `app/channels/application_cable/connection.rb` for details.
