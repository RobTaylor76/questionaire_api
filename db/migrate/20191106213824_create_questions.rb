class CreateQuestions < ActiveRecord::Migration[6.0]
  def change
    create_table :questions do |t|
      t.references :inspection_type
      t.references :client
      t.integer :sequence
      t.boolean :allow_not_applicable_response, default: false
      t.string :uuid
      t.text :text
      t.jsonb :answers
    end
  end
end
