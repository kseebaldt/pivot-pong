 require 'rails_helper'

describe Lemons do
  let(:me) { Player.create(name: "me") }

  it "should populate achievement specific attributes to achievement on create" do
    achievement = nil
    expect { achievement = Lemons.create(player: me) }.to change(me.achievements, :count).by(1)
    expect(achievement.title).to eq "When Life Gives You Lemons..."
    expect(achievement.description).to eq "Lose 5 matches in a row"
    expect(achievement.badge).to eq "fa fa-lemon-o"
  end

  describe "#eligible" do
    let(:you) { Player.create(name: "you") }

    it "should be eligible if you lose 5 matches in a row" do
      create(:match, winner: me, loser: you, occurred_at: 5.days.ago)
      create(:match, winner: me, loser: you, occurred_at: 4.days.ago)
      create(:match, winner: me, loser: you, occurred_at: 3.days.ago)
      create(:match, winner: me, loser: you, occurred_at: 2.days.ago)
      create(:match, winner: me, loser: you, occurred_at: 1.days.ago)
      expect(Lemons.eligible?(you)).to be true
      expect(Lemons.eligible?(me)).to be false
    end

    it "should be not eligible if you don't lose 5 matches in a row" do
      create(:match, winner: me, loser: you, occurred_at: 5.days.ago)
      create(:match, winner: me, loser: you, occurred_at: 4.days.ago)
      create(:match, winner: you, loser: me, occurred_at: 3.days.ago)
      create(:match, winner: me, loser: you, occurred_at: 2.days.ago)
      create(:match, winner: me, loser: you, occurred_at: 1.days.ago)
      expect(Lemons.eligible?(me)).to be false
      expect(Lemons.eligible?(you)).to be false
    end
  end
end
