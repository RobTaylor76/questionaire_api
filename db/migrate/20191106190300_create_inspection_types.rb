class CreateInspectionTypes < ActiveRecord::Migration[6.0]
  def change
    create_table :inspection_types do |t|
      t.references :client
      t.string :uuid
      t.integer :interval
      t.string :name
    end
  end
end
