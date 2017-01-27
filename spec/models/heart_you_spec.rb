require 'spec_helper'

describe HeartYou do
  let(:me) { Player.create(name: "me") }

  it "should populate achievement specific attributes to achievement on create" do
    achievement = nil
    expect { achievement = HeartYou.create(player: me) }.to change(me.achievements, :count).by(1)
    expect(achievement.title).to eq "I Heart You"
    expect(achievement.description).to eq "Last 3 logged matches were with the same person"
    expect(achievement.badge).to eq "icon-heart"
  end

  describe "#eligible" do
    let(:you) { Player.create(name: "you") }
    it "should be eligible if your last 3 matches logged were with the same person" do
      Match.create(winner: me, loser: you, occured_at: 3.days.ago)
      Match.create(winner: me, loser: you, occured_at: 2.days.ago)
      Match.create(winner: me, loser: you, occured_at: 1.days.ago)
      expect(HeartYou.eligible?(me)).to be true
    end
  end
end
