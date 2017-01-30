class AddOccuredAtToLogs < ActiveRecord::Migration
  def change
    add_column :logs, :occured_at, :datetime
    Log.all.find_each { |log| log.update_column(:occured_at, log.created_at) }
  end
end
