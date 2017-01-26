require 'spec_helper'

describe Streak do
  let(:me) { Player.create(name: "me") }

  it "should populate achievement specific attributes to achievement on create" do
    achievement = nil
    expect { achievement = Streak.create(player: me) }.to change(me.achievements, :count).by(1)
    achievement.title.should == "You're on a Streak!"
    achievement.description.should == "Win 5 matches in a row"
    achievement.badge.should == "icon-fire"
  end

  describe "#eligible" do
    let(:you) { Player.create(name: "you") }

    it "should be eligible if you win 5 matches in a row" do
      Match.create(winner: me, loser: you, occured_at: 5.days.ago)
      Match.create(winner: me, loser: you, occured_at: 4.days.ago)
      Match.create(winner: me, loser: you, occured_at: 3.days.ago)
      Match.create(winner: me, loser: you, occured_at: 2.days.ago)
      Match.create(winner: me, loser: you, occured_at: 1.days.ago)
      Streak.eligible?(me).should be true
      Streak.eligible?(you).should be false
    end

    it "should be not eligible if you don't win 5 matches in a row" do
      Match.create(winner: me, loser: you, occured_at: 5.days.ago)
      Match.create(winner: me, loser: you, occured_at: 4.days.ago)
      Match.create(winner: you, loser: me, occured_at: 3.days.ago)
      Match.create(winner: me, loser: you, occured_at: 2.days.ago)
      Match.create(winner: me, loser: you, occured_at: 1.days.ago)
      Streak.eligible?(me).should be false
      Streak.eligible?(you).should be false
    end
  end
end
