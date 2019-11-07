class AddAnswersToInspection < ActiveRecord::Migration[6.0]
  def change
    add_column :inspections, :answers, :jsonb, default: []
  end
end
