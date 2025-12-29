module Live
  class TeamBuilder < LiveCable::Component
    reactive :contact_id, -> { nil }
    reactive :contact, -> { Contact.new }
    reactive :contacts, -> { {} }
    reactive :team
    reactive :names_by_role, -> {
      %w[engineer designer].index_with { 5.times.map { Faker::Name.first_name }.uniq }
    }

    def names_for_role
      names_by_role[contact.role] || []
    end

    actions :form, :save

    def form(params)
      contact.role = params.dig(:contact, :role)
      contact.name = params.dig(:contact, :name)
      contact.validate
    end

    def save(params)
      if contact.save
        contacts[team] ||= []
        contacts[team] << contact

        self.contact = Contact.new
      end
    end
  end
end
