require 'rails_helper'

describe WelcomeMat do
  let(:me) { create(:player) }

  it "should populate achievement specific attributes to achievement on create" do
    achievement = nil
    expect { achievement = WelcomeMat.create(player: me) }.to change(me.achievements, :count).by(1)
    expect(achievement.title).to eq "Laying Out the Welcome Mat"
    expect(achievement.description).to eq "Play someone not on the ladder"
    expect(achievement.badge).to eq "fa fa-plus"
  end

  describe "#eligible" do
    let(:you) { create(:player) }
    let(:him) { create(:player) }
    let!(:match) { create(:match, winner: me, loser: you) }
    let!(:match_2) { create(:match, winner: me, loser: him) }

    it "should be eligible if you play someone not yet on the ladder(only 1 match)" do
      expect(me.matches.size).to eq 2
      expect(him.matches.size).to eq 1
      expect(WelcomeMat.eligible?(me)).to be true
      expect(WelcomeMat.eligible?(him)).to_not be true
    end
  end
end
