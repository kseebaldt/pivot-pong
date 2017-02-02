require 'rails_helper'

describe ApisController do
  describe "#tweet" do
    let(:me) { Player.create(name: "me") }
    let(:you) { Player.create(name: "you") }
    let!(:match) { create(:match, winner: me, loser: you) }

    it "should award the Bragging Rights badge to the winner" do
      expect { get :tweet, match_id: match.id }.to change(BraggingRights, :count).by(1)
      expect(me.reload.achievements.map(&:class)).to include(BraggingRights)
      expect(you.reload.achievements.map(&:class)).to_not include(BraggingRights)
    end

    it "should not award the Bragging Rights badge if the winner has it already" do
      BraggingRights.create(player: me, match: match)
      expect { get :tweet, match_id: match.id }.to change(BraggingRights, :count).by(0)
    end
  end
end
