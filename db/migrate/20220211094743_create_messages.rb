class CreateMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :messages do |t|
      t.integer :team_id
      t.text :content
      t.string :title

      t.timestamps
    end
  end
end
