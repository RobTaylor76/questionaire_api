class AddFirstInspectionDateToInspectionType < ActiveRecord::Migration[6.0]
  def change
    add_column :inspection_types, :first_inspection_date, :date
  end
end
