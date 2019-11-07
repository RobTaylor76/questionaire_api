class Client < ApplicationRecord
  has_many :inspection_types
  has_many :questions
  has_many :inspections
end