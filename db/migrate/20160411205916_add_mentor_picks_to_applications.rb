class AddMentorPicksToApplications < ActiveRecord::Migration
  def change
    add_column :applications, :mentor_pick_project1, :boolean
    add_column :applications, :mentor_pick_project2, :boolean
  end
end
