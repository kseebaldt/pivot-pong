require 'spec_helper'

describe LittleBen do
  let(:me) { Player.create(name: "me") }

  it "should populate achievement specific attributes to achievement on create" do
    achievement = nil
    expect { achievement = LittleBen.create(player: me) }.to change(me.achievements, :count).by(1)
    achievement.title.should == "Little Ben!"
    achievement.description.should == "Played more than 50 matches"
    achievement.badge.should == "icon-tag"
  end

  describe "#eligible" do
    it "should be eligible if you log more than 50 matches" do
      me.stub_chain(:matches, :descending, :limit, :size).and_return(50)
      LittleBen.eligible?(me).should be true
    end
  end
end
