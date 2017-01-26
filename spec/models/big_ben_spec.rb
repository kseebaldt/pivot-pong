require 'spec_helper'

describe BigBen do
  let(:me) { Player.create(name: "me") }

  it "should populate achievement specific attributes to achievement on create" do
    achievement = nil
    expect { achievement = BigBen.create(player: me) }.to change(me.achievements, :count).by(1)
    achievement.title.should == "Big Ben!"
    achievement.description.should == "Played more than 100 matches"
    achievement.badge.should == "icon-tags"
  end

  describe "#eligible" do
    it "should be eligible if you log more than 100 matches" do
      me.stub_chain(:matches, :limit, :size).and_return(100)
      BigBen.eligible?(me).should be true
    end
  end
end
