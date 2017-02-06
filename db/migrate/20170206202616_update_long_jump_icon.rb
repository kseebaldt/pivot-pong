class UpdateLongJumpIcon < ActiveRecord::Migration
  def up
    execute "UPDATE achievements SET badge = 'fa fa-arrow-circle-up' WHERE badge = 'fa fa-long-arrow-up'"
  end

  def down
    execute "UPDATE achievements SET badge = 'fa fa-long-arrow-up' WHERE badge = 'fa fa-arrow-circle-up'"
  end
end
