class ConvertTwitterIcon < ActiveRecord::Migration
  def up
    execute "UPDATE achievements SET badge = 'fa fa-twitter' WHERE badge = 'icon-twitter'"
  end

  def down
    execute "UPDATE achievements SET badge = 'icon-twitter' WHERE badge = 'fa fa-twitter'"
  end
end
