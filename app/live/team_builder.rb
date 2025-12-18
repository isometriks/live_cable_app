module Live
  class TeamBuilder < LiveCable::Component
    reactive :contact_id, -> { nil }
    reactive :contact, -> { Contact.new }
    reactive :contacts, -> { {} }
    reactive :team

    actions :form, :save

    def form(params)
      contact.gender = params.dig(:contact, :gender)
      contact.name = params.dig(:contact, :name)
      contact.validate
    end

    def save(params)
      if contact.save
        puts "Team is #{team.inspect} #{team.class.name}"
        contacts[team] ||= []
        contacts[team] << contact

        self.contact = Contact.new
      end
    end
  end
end
