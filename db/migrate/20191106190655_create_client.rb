class CreateClient < ActiveRecord::Migration[6.0]
  def change
    create_table :clients do |t|
      t.string :uuid
      t.string :name
    end
  end
end
