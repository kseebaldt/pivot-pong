require 'rails_helper'

describe Streak do
  let(:me) { Player.create(name: "me") }

  it "should populate achievement specific attributes to achievement on create" do
    achievement = nil
    expect { achievement = Streak.create(player: me) }.to change(me.achievements, :count).by(1)
    expect(achievement.title).to eq "You're on a Streak!"
    expect(achievement.description).to eq "Win 5 matches in a row"
    expect(achievement.badge).to eq "fa fa-fire"
  end

  describe "#eligible" do
    let(:you) { Player.create(name: "you") }

    it "should be eligible if you win 5 matches in a row" do
      create(:match, winner: me, loser: you, occured_at: 5.days.ago)
      create(:match, winner: me, loser: you, occured_at: 4.days.ago)
      create(:match, winner: me, loser: you, occured_at: 3.days.ago)
      create(:match, winner: me, loser: you, occured_at: 2.days.ago)
      create(:match, winner: me, loser: you, occured_at: 1.days.ago)
      expect(Streak.eligible?(me)).to be true
      expect(Streak.eligible?(you)).to be false
    end

    it "should be not eligible if you don't win 5 matches in a row" do
      create(:match, winner: me, loser: you, occured_at: 5.days.ago)
      create(:match, winner: me, loser: you, occured_at: 4.days.ago)
      create(:match, winner: you, loser: me, occured_at: 3.days.ago)
      create(:match, winner: me, loser: you, occured_at: 2.days.ago)
      create(:match, winner: me, loser: you, occured_at: 1.days.ago)
      expect(Streak.eligible?(me)).to be false
      expect(Streak.eligible?(you)).to be false
    end
  end
end
