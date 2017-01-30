class Admin::SiteSettingsController < Admin::BaseController
  def index
    @general_settings = SiteSetting.where(setting_type: SiteSetting::GENERAL_SETTINGS)
    @player_settings = SiteSetting.where(setting_type: SiteSetting::PLAYER_SETTINGS)
  end

  def group
    settings = params[:site_settings]
    settings.keys.each do |setting_type|
      if updateable = SiteSetting.where(setting_type: setting_type).first
        updateable.update_column(:value, settings[setting_type]["value"])
      end
    end
    flash[:notice] = "Styles updated."
    redirect_to admin_site_settings_path
  end

  def restore_defaults
    SiteSetting.update_all(value: nil)
    flash[:notice] = "Defaults Restored."
    redirect_to admin_site_settings_path
  end
end