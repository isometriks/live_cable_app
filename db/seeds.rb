# Sample contacts for the Team Builder example
%w[engineer designer].each do |role|
  3.times do
    Contact.find_or_create_by!(
      name: Faker::Name.first_name,
      role: role
    )
  end
end

puts "Seeded #{Contact.count} contacts"
