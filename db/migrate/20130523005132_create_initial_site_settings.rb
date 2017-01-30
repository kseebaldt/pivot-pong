class CreateInitialSiteSettings < ActiveRecord::Migration
  def up
    SiteSetting::ALL_SETTINGS.each do |setting|
      SiteSetting.find_or_create_by(setting_type: setting)
    end
  end

  def down
    SiteSetting.destroy_all
  end
end
