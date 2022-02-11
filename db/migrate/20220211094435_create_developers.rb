class CreateDevelopers < ActiveRecord::Migration[6.0]
  def change
    create_table :developers do |t|
      t.string :full_name
      t.string :email
      t.bigint :mobile

      t.timestamps
    end
  end
end
