class TeamBuilder < LiveCable::Component
  reactive :contact_id, -> { raise NotImplementedError }
  reactive :contact, ->(component) { Contact.find(component.contact_id) }
  reactive :contacts, -> { {} }
  reactive :team

  actions :form, :save

  def form(params)
    contact.assign_attributes(params.expect(contact: [:name, :gender]))
    contact.validate

    dirty :contact
  end

  def save(params)
    if contact.save
      contacts[team] ||= []
      contacts[team] << contact

      self.contact = Contact.new
    end

    dirty :contacts, :contact
  end
end
