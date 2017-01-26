require 'spec_helper'

describe Lemons do
  let(:me) { Player.create(name: "me") }

  it "should populate achievement specific attributes to achievement on create" do
    achievement = nil
    expect { achievement = Lemons.create(player: me) }.to change(me.achievements, :count).by(1)
    achievement.title.should == "When Life Gives You Lemons..."
    achievement.description.should == "Lose 5 matches in a row"
    achievement.badge.should == "icon-lemon"
  end

  describe "#eligible" do
    let(:you) { Player.create(name: "you") }

    it "should be eligible if you lose 5 matches in a row" do
      Match.create(winner: me, loser: you, occured_at: 5.days.ago)
      Match.create(winner: me, loser: you, occured_at: 4.days.ago)
      Match.create(winner: me, loser: you, occured_at: 3.days.ago)
      Match.create(winner: me, loser: you, occured_at: 2.days.ago)
      Match.create(winner: me, loser: you, occured_at: 1.days.ago)
      Lemons.eligible?(you).should be true
      Lemons.eligible?(me).should be false
    end

    it "should be not eligible if you don't lose 5 matches in a row" do
      Match.create(winner: me, loser: you, occured_at: 5.days.ago)
      Match.create(winner: me, loser: you, occured_at: 4.days.ago)
      Match.create(winner: you, loser: me, occured_at: 3.days.ago)
      Match.create(winner: me, loser: you, occured_at: 2.days.ago)
      Match.create(winner: me, loser: you, occured_at: 1.days.ago)
      Lemons.eligible?(me).should be false
      Lemons.eligible?(you).should be false
    end
  end
end
