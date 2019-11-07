class CreateInspections < ActiveRecord::Migration[6.0]
  def change
    create_table :inspections do |t|
      t.references :inspection_type
      t.references :client
      t.date  :due_date
      t.string :uuid
      t.boolean :complete, default: false
      t.integer :score
    end
  end
end
