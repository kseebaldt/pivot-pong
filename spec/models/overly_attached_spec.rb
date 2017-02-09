require 'rails_helper'

describe OverlyAttached do
  let(:me) { Player.create(name: "me") }

  it "should populate achievement specific attributes to achievement on create" do
    achievement = nil
    expect { achievement = OverlyAttached.create(player: me) }.to change(me.achievements, :count).by(1)
    expect(achievement.title).to eq "Overly Attached"
    expect(achievement.description).to eq "Last 6 matches were with the same person"
    expect(achievement.badge).to eq "fa fa-magnet"
  end

  describe "#eligible" do
    let(:you) { Player.create(name: "you") }
    it "should be eligible if your last 6 matches logged were with the same person" do
      create(:match, winner: me, loser: you, occurred_at: 6.days.ago)
      create(:match, winner: me, loser: you, occurred_at: 5.days.ago)
      create(:match, winner: me, loser: you, occurred_at: 4.days.ago)
      create(:match, winner: me, loser: you, occurred_at: 3.days.ago)
      create(:match, winner: me, loser: you, occurred_at: 2.days.ago)
      create(:match, winner: me, loser: you, occurred_at: 1.days.ago)
      expect(OverlyAttached.eligible?(me)).to be true
    end

    it "should not be eligible if less than 6 matches are logged" do
      create(:match, winner: me, loser: you, occurred_at: 5.days.ago)
      create(:match, winner: me, loser: you, occurred_at: 4.days.ago)
      create(:match, winner: me, loser: you, occurred_at: 3.days.ago)
      create(:match, winner: me, loser: you, occurred_at: 2.days.ago)
      create(:match, winner: me, loser: you, occurred_at: 1.days.ago)
      expect(OverlyAttached.eligible?(me)).to be false
    end

    it "should not be eligible if you played more than one different opponent over you last 6 matches" do
      create(:match, winner: me, loser: you, occurred_at: 6.days.ago)
      create(:match, winner: me, loser: you, occurred_at: 5.days.ago)
      create(:match, winner: me, loser: you, occurred_at: 4.days.ago)
      create(:match, winner: me, loser: you, occurred_at: 3.days.ago)
      create(:match, winner: me, loser: you, occurred_at: 2.days.ago)
      create(:match, winner: me, loser: create(:player), occurred_at: 1.days.ago)
      expect(OverlyAttached.eligible?(me)).to be false
    end
  end
end
