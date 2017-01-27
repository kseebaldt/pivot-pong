require 'spec_helper'

describe SiteSetting do
  it "requires a setting type" do
    expect(SiteSetting.new).to_not be_valid
  end

  describe "#create" do
    it "should only create a valid site setting" do
      expect(SiteSetting.new(setting_type: "foo", value: "bar")).to_not be_valid
      expect(SiteSetting.new(setting_type: SiteSetting::GENERAL_SETTINGS.first, value: "bar")).to be_valid
    end
  end
end
