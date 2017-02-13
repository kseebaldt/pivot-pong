require 'rails_helper'

describe HeartYou do
  let(:me) { Player.create(name: "me") }
  let(:you) { Player.create(name: "you") }

  it "should have a class level description" do
    expect(HeartYou.description).to eq "Last 3 logged matches were with the same person"
  end

  it "should populate achievement specific attributes to achievement on create" do
    achievement = nil
    match = create(:match, winner: me, loser: you)
    expect { achievement = HeartYou.create(player: me, match: match) }.to change(me.achievements, :count).by(1)
    expect(achievement.title).to eq "I Heart You"
    expect(achievement.description).to eq "Last 3 logged matches were with you"
    expect(achievement.badge).to eq "fa fa-heart"
  end

  describe "#eligible" do
    it "should be eligible if your last 3 matches logged were with the same person" do
      create(:match, winner: create(:player), loser: me, occurred_at: 4.days.ago)
      create(:match, winner: me, loser: you, occurred_at: 3.days.ago)
      create(:match, winner: me, loser: you, occurred_at: 2.days.ago)
      create(:match, winner: me, loser: you, occurred_at: 1.days.ago)
      expect(HeartYou.eligible?(me)).to be true
      expect(HeartYou.eligible?(you)).to be true
    end

    it "should not be eligible if less than 3 matches are logged" do
      create(:match, winner: me, loser: you, occurred_at: 2.days.ago)
      create(:match, winner: me, loser: you, occurred_at: 1.days.ago)
      expect(HeartYou.eligible?(me)).to be false
    end

    it "should not be eligible if you played more than one different opponent over your last 3 matches" do
      create(:match, winner: me, loser: you, occurred_at: 3.days.ago)
      create(:match, winner: me, loser: you, occurred_at: 2.days.ago)
      create(:match, winner: me, loser: create(:player), occurred_at: 1.days.ago)
      expect(HeartYou.eligible?(me)).to be false
    end
  end
end
