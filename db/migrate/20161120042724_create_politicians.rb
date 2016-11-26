class CreatePoliticians < ActiveRecord::Migration
  def change
    create_table :politicians do |t|
      t.string :first_name
      t.string :last_name
      t.string :party
      t.string :phone
      t.string :state
      t.string :position
      t.boolean :denounced

      t.timestamps null: false
    end
  end
end
