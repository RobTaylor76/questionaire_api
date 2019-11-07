class InspectionType < ApplicationRecord
  belongs_to :client
  has_many :questions
  has_many :inspections
end