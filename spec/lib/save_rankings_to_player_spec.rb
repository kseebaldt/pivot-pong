require 'rails_helper'
require 'save_rankings_to_player'

describe SaveRankingsToPlayer do
  describe ".run" do
    let!(:p1) { Player.create(name: "Foo") }
    let!(:p2) { Player.create(name: "Bar") }
    let!(:p3) { Player.create(name: "Baz") }
    let!(:p4) { Player.create(name: "Quux") }

    context "when no matches exist" do
      it "doesn't assign ranks" do
        SaveRankingsToPlayer.run

        expect(p1.reload.rank).to be_nil
        expect(p2.reload.rank).to be_nil
        expect(p3.reload.rank).to be_nil
        expect(p4.reload.rank).to be_nil
      end
    end

    it "clears out any existing ranks" do
      p3.update_attributes :rank => 3

      SaveRankingsToPlayer.run
      expect(p3.reload.rank).to be_nil
    end

    context "when matches exists" do
      let!(:m1) { create(:match, winner: p1, loser: p2, occured_at: 1.day.ago) }

      it "assigns ranks for players in the match" do
        Player.update_all(:active => false)
        SaveRankingsToPlayer.run

        expect(p1.reload.rank).to eq 1
        expect(p2.reload.rank).to eq 2
        expect(p3.reload.rank).to be_nil
        expect(p4.reload.rank).to be_nil
      end

      context "multiple matches" do
        let!(:m2) { create(:match, winner: p2, loser: p1) }

        it "sorts winners" do
          Player.update_all(:active => false)
          SaveRankingsToPlayer.run

          expect(p1.reload.rank).to eq 2
          expect(p2.reload.rank).to eq 1
          expect(p3.reload.rank).to be_nil
          expect(p4.reload.rank).to be_nil
        end
      end

      context "moving halfway to the winner" do
        let!(:m2) { create(:match, winner: p2, loser: p3) }
        let!(:m3) { create(:match, winner: p4, loser: p1) }

        it "moves the winner halfway to the loser" do
          Player.update_all :active => true

          SaveRankingsToPlayer.run

          expect(p1.reload.rank).to eq 1
          expect(p2.reload.rank).to eq 3
          expect(p3.reload.rank).to eq 4
          expect(p4.reload.rank).to eq 2
        end
      end
    end
  end
end
