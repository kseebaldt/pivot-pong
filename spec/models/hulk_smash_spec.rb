require 'rails_helper'

describe HulkSmash do
  let(:me) { Player.create(name: "me") }

  it "should populate achievement specific attributes to achievement on create" do
    achievement = nil
    expect { achievement = HulkSmash.create(player: me) }.to change(me.achievements, :count).by(1)
    expect(achievement.title).to eq "Hulk Smash"
    expect(achievement.description).to eq "Overall win record vs. someone spreads 10 or more"
    expect(achievement.badge).to eq "fa fa-legal"
  end

  describe "#eligible" do
    let(:you) { Player.create(name: "you") }
    it "should be eligible if you have won 10 more matches vs your opponent than they have vs you" do
      create(:match, winner: you, loser: me, occured_at: 12.days.ago)
      create(:match, winner: me, loser: you, occured_at: 11.days.ago)
      create(:match, winner: me, loser: you, occured_at: 10.days.ago)
      create(:match, winner: me, loser: you, occured_at: 9.days.ago)
      create(:match, winner: me, loser: you, occured_at: 8.days.ago)
      create(:match, winner: me, loser: you, occured_at: 7.days.ago)
      create(:match, winner: me, loser: you, occured_at: 6.days.ago)
      create(:match, winner: me, loser: you, occured_at: 5.days.ago)
      create(:match, winner: me, loser: you, occured_at: 4.days.ago)
      create(:match, winner: me, loser: you, occured_at: 3.days.ago)
      create(:match, winner: me, loser: you, occured_at: 2.days.ago)
      create(:match, winner: me, loser: you, occured_at: 1.days.ago)
      expect(HulkSmash.eligible?(me)).to be true
      expect(HulkSmash.eligible?(you)).to be false
    end

    it "should not be eligible if you have won less than 10 more matches vs your opponent than they have vs you" do
      create(:match, winner: you, loser: me, occured_at: 11.days.ago)
      create(:match, winner: me, loser: you, occured_at: 10.days.ago)
      create(:match, winner: me, loser: you, occured_at: 9.days.ago)
      create(:match, winner: me, loser: you, occured_at: 8.days.ago)
      create(:match, winner: me, loser: you, occured_at: 7.days.ago)
      create(:match, winner: me, loser: you, occured_at: 6.days.ago)
      create(:match, winner: me, loser: you, occured_at: 5.days.ago)
      create(:match, winner: me, loser: you, occured_at: 4.days.ago)
      create(:match, winner: me, loser: you, occured_at: 3.days.ago)
      create(:match, winner: me, loser: you, occured_at: 2.days.ago)
      create(:match, winner: me, loser: you, occured_at: 1.days.ago)
      expect(HulkSmash.eligible?(me)).to be false
    end
  end
end
