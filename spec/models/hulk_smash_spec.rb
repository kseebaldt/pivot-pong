require 'spec_helper'

describe HulkSmash do
  let(:me) { Player.create(name: "me") }

  it "should populate achievement specific attributes to achievement on create" do
    achievement = nil
    expect { achievement = HulkSmash.create(player: me) }.to change(me.achievements, :count).by(1)
    achievement.title.should == "Hulk Smash"
    achievement.description.should == "Overall win record vs. someone spreads 10 or more"
    achievement.badge.should == "icon-legal"
  end

  describe "#eligible" do
    let(:you) { Player.create(name: "you") }
    it "should be eligible if your last 3 matches logged were with the same person" do
      Match.create(winner: me, loser: you, occured_at: 10.days.ago)
      Match.create(winner: me, loser: you, occured_at: 9.days.ago)
      Match.create(winner: me, loser: you, occured_at: 8.days.ago)
      Match.create(winner: me, loser: you, occured_at: 7.days.ago)
      Match.create(winner: me, loser: you, occured_at: 6.days.ago)
      Match.create(winner: me, loser: you, occured_at: 5.days.ago)
      Match.create(winner: me, loser: you, occured_at: 4.days.ago)
      Match.create(winner: me, loser: you, occured_at: 3.days.ago)
      Match.create(winner: me, loser: you, occured_at: 2.days.ago)
      Match.create(winner: me, loser: you, occured_at: 1.days.ago)
      HulkSmash.eligible?(me).should be true
      HulkSmash.eligible?(you).should be false
    end
  end
end
