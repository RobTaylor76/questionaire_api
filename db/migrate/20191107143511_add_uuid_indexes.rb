class AddUuidIndexes < ActiveRecord::Migration[6.0]
  def change
    add_index :inspections, :uuid
    add_index :inspection_types, :uuid
    add_index :clients, :uuid
    add_index :questions, :uuid
  end
end
