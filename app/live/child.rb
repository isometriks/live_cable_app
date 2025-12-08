module Live
  class Child < LiveCable::Component
    reactive :value, -> { false }
    actions :dupe

    def dupe
      self.value = true
    end
  end
end
