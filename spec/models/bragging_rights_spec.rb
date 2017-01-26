require 'spec_helper'

describe BraggingRights do
  let(:me) { Player.create(name: "me") }

  it "should populate achievement specific attributes to achievement on create" do
    achievement = nil
    expect { achievement = BraggingRights.create(player: me) }.to change(me.achievements, :count).by(1)
    achievement.title.should == "Bragging Rights"
    achievement.description.should == "Tweet Your Victory"
    achievement.badge.should == "icon-twitter"
  end

  describe "#eligible" do
    it "should never be eligible" do
      BraggingRights.eligible?(me).should be false
    end
  end
end
