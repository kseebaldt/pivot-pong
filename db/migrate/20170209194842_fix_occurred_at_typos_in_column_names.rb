class FixOccurredAtTyposInColumnNames < ActiveRecord::Migration
  def self.up
    rename_column :logs, :occured_at, :occurred_at
    rename_column :matches, :occured_at, :occurred_at
  end

  def self.down
    rename_column :logs, :occurred_at, :occured_at
    rename_column :matches, :occurred_at, :occured_at
  end
end
