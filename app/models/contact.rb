class Contact < ApplicationRecord
  validates :name, presence: true
  validates :role, inclusion: { in: %w[engineer designer] }
end
