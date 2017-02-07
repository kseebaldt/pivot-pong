require 'rails_helper'

describe MorningMadness do
  let(:me) { Player.create(name: "me") }

  it "should populate achievement specific attributes to achievement on create" do
    achievement = nil
    expect { achievement = MorningMadness.create(player: me) }.to change(me.achievements, :count).by(1)
    expect(achievement.title).to eq "Morning Madness"
    expect(achievement.description).to eq "Log a match before 9am PST"
    expect(achievement.badge).to eq "fa fa-adjust"
  end

  describe "#eligible" do
    let(:you) { Player.create(name: "you") }
    it "should be eligible if you Log a match before 9am PST" do
      create(:match, winner: me, loser: you, occured_at: (Date.today.beginning_of_day + 8.hours))
      expect(MorningMadness.eligible?(me)).to be true
      expect(MorningMadness.eligible?(you)).to be true
    end

    it "should not be eligible if you Log a match after 9am PST" do
      create(:match, winner: me, loser: you, occured_at: (Date.today.beginning_of_day + 10.hours))
      expect(MorningMadness.eligible?(me)).to be false
      expect(MorningMadness.eligible?(you)).to be false
    end
  end
end
