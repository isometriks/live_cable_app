class Contact < ApplicationRecord
  validates :name, presence: true
  validates :gender, inclusion: { in: %w[male female] }
end
