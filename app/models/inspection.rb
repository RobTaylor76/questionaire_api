class Inspection < ApplicationRecord
  belongs_to :client
  belongs_to :inspection_type
end