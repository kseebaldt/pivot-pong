require 'spec_helper'

describe Inactive do
  let(:me) { Player.create(name: "me") }

  it "should populate achievement specific attributes to achievement on create" do
    achievement = nil
    expect { achievement = Inactive.create(player: me) }.to change(me.achievements, :count).by(1)
    achievement.title.should == "Where'd You Go?"
    achievement.description.should == "Gone inactive after 30 days of not playing"
    achievement.badge.should == "icon-remove-circle"
  end

  describe "#eligible" do
    it "should never be eligible, awarded during mark as inactive" do
      Inactive.eligible?(me).should be false
    end
  end
end
