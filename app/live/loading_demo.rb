module Live
  # A playground for the two newest LiveCable features:
  #
  #   * Loading states - `live-loading` / `live-disable-with`
  #   * Server events   - `dispatch_event`
  #
  # Every action sleeps for `latency` milliseconds so the in-flight state is
  # actually visible on localhost, where round trips are otherwise instant.
  class LoadingDemo < LiveCable::Component
    reactive :latency, -> { 750 }, writable: true
    reactive :query, -> { "" }, writable: true
    reactive :saved_at
    reactive :notes, -> { [] }

    actions :save, :noop, :ping, :add_note, :clear_notes

    ITEMS = [
      "Reactive Variables",
      "Lifecycle Callbacks",
      "Actions & Events",
      "Loading States",
      "Server Events",
      "Compound Components",
      "Partial Rendering",
      "Streaming",
      "Shared State"
    ].freeze

    MAX_LATENCY = 3000

    # Changes state, so the client gets a `_refresh` - which also clears the
    # loading state.
    def save
      simulate_work

      self.saved_at = Time.current

      dispatch_event("toast:show", message: "Settings saved", level: "success", window: true)
    end

    # Changes nothing at all, so there's no re-render. The server still sends
    # a lightweight `_ack` so the button never gets stuck disabled.
    def noop
      simulate_work
    end

    # Dispatches an event without touching any state - delivered on its own,
    # with no re-render attached.
    def ping
      simulate_work

      dispatch_event("demo:pinged", at: Time.current.strftime("%-l:%M:%S %p"))
    end

    def add_note(params)
      simulate_work

      text = params[:note].to_s.strip
      return if text.blank?

      note = { id: SecureRandom.uuid, text: text, at: Time.current.strftime("%-l:%M:%S %p") }
      notes << note

      # Fires after the morph, so the handler can find the note it just added
      dispatch_event("demo:note-added", id: note[:id])
    end

    def clear_notes
      simulate_work

      notes.clear
    end

    # Reactive writes don't run an action, so the latency lives in the
    # "search" itself - that's what keeps the input's live-loading state on
    # screen long enough to see.
    def results
      return ITEMS if query.blank?

      simulate_work

      ITEMS.select { |item| item.downcase.include?(query.to_s.downcase) }
    end

    def latency_ms
      latency.to_i.clamp(0, MAX_LATENCY)
    end

    def saved_label
      saved_at ? saved_at.strftime("%-l:%M:%S %p") : "never"
    end

    private

    def simulate_work
      sleep(latency_ms / 1000.0)
    end
  end
end
