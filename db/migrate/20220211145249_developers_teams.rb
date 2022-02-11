class DevelopersTeams < ActiveRecord::Migration[6.0]
  def change
    create_table :developers_teams do |t|
      t.belongs_to :developer
      t.belongs_to :team
    end
  end
end
