class NavBar < LiveCable::Component
  reactive :contact, -> { Contact.new }, shared: true
end
