class AddContainerBackgroundToSiteSettings < ActiveRecord::Migration
  def up
    SiteSetting.find_or_create_by(setting_type: "container background color")
  end

  def down
    if setting = SiteSetting.find_by_setting_type("container background color")
      setting.destroy
    end
  end
end
