class RemoveTitleDescriptionAndBadgeFromAchievement < ActiveRecord::Migration
  def self.up
    remove_column :achievements, :title
    remove_column :achievements, :description
    remove_column :achievements, :badge
  end

  def self.down
    add_column :achievements, :title, :string
    add_column :achievements, :description, :text
    add_column :achievements, :badge, :string
  end
end