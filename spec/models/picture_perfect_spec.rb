require 'spec_helper'

describe PicturePerfect do
  let(:me) { Player.create(name: "me") }

  it "should populate achievement specific attributes to achievement on create" do
    achievement = nil
    expect { achievement = PicturePerfect.create(player: me) }.to change(me.achievements, :count).by(1)
    achievement.title.should == "Picture Perfect"
    achievement.description.should == "Upload an avatar in your user profile"
    achievement.badge.should == "icon-camera"
  end

  describe "#eligible" do
    it "should never be eligible" do
      PicturePerfect.eligible?(me).should be false
    end
  end
end
