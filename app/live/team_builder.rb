class TeamBuilder < LiveCable::Component
  reactive :contact, -> { Contact.new }, shared: true
  reactive :contacts, -> { [] }

  def form(params)
    contact.assign_attributes(params.expect(contact: [:name, :gender]))
    contact.validate

    dirty :contact
  end

  def save(params)
    if contact.save
      contacts << contact
      self.contact = Contact.new
    end

    dirty :contacts, :contact
  end
end
