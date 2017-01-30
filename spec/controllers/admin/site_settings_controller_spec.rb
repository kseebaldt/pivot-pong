require 'spec_helper'

describe Admin::SiteSettingsController do
  describe "#index" do
    it "assigns general settings and player settings" do
      get :index
      expect(assigns(:general_settings)).to eq SiteSetting.where(setting_type: SiteSetting::GENERAL_SETTINGS)
      expect(assigns(:player_settings)).to eq SiteSetting.where(setting_type: SiteSetting::PLAYER_SETTINGS)
    end
  end

  describe "#group" do
    it "updates the settings submitted by the form" do
      setting = SiteSetting.create!(setting_type: "link color", value: "foo")
      params = {site_settings: {
          "link color" => {"value" => "bar"}
      }}
      post :group, params
      expect(setting.reload.value).to eq "bar"
    end
  end
end
