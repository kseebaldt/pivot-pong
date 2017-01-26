require 'spec_helper'

describe OverlyAttached do
  let(:me) { Player.create(name: "me") }

  it "should populate achievement specific attributes to achievement on create" do
    achievement = nil
    expect { achievement = OverlyAttached.create(player: me) }.to change(me.achievements, :count).by(1)
    achievement.title.should == "Overly Attached"
    achievement.description.should == "Last 6 matches were with the same person"
    achievement.badge.should == "icon-magnet"
  end

  describe "#eligible" do
    let(:you) { Player.create(name: "you") }
    it "should be eligible if your last 6 matches logged were with the same person" do
      Match.create(winner: me, loser: you, occured_at: 6.days.ago)
      Match.create(winner: me, loser: you, occured_at: 5.days.ago)
      Match.create(winner: me, loser: you, occured_at: 4.days.ago)
      Match.create(winner: me, loser: you, occured_at: 3.days.ago)
      Match.create(winner: me, loser: you, occured_at: 2.days.ago)
      Match.create(winner: me, loser: you, occured_at: 1.days.ago)
      HeartYou.eligible?(me).should be true
    end
  end
end
