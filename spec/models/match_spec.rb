require 'rails_helper'

describe Match do
  describe "validations" do
    subject { Match.new }
    it { should_not be_valid }
  end

  describe "updating player ranks" do
    let!(:p1) { Player.create(name: "p1") }
    let!(:p2) { Player.create(name: "p2") }
    let!(:p3) { Player.create(name: "p3") }
    let!(:p4) { Player.create(name: "p4") }
    let!(:p5) { Player.create(name: "p5") }
    let(:establishing_match1) { build(:match, winner: p1.reload, loser: p4.reload) }
    let(:establishing_match2) { build(:match, winner: p3.reload, loser: p4.reload) }
    let(:establishing_match3) { build(:match, winner: p2.reload, loser: p1.reload) }

    before do
      establishing_match1.save!
      MatchObserver.after_save(establishing_match1)
      establishing_match2.save!
      MatchObserver.after_save(establishing_match2)
      establishing_match3.save!
      MatchObserver.after_save(establishing_match3)
      expect(Match.order(:id)).to eq [establishing_match1, establishing_match2, establishing_match3]
      expect(establishing_match1.winner).to eq p1
      expect(establishing_match1.loser).to eq p4

      expect(p1.reload).to be_active
      expect(p2.reload).to be_active
      expect(p3.reload).to be_active
      expect(p4.reload).to be_active
      expect(p5.reload).to be_inactive

      expect(p1.rank).to eq 1
      expect(p2.rank).to eq 2
      expect(p3.rank).to eq 3
      expect(p4.rank).to eq 4
      expect(p5.rank).to be_nil
    end

    context "when the players are next to each other" do
      it "should update those players ranks" do
        MatchObserver.after_save create(:match, winner: p3, loser: p2)

        expect(p3.reload.rank).to eq 2
        expect(p2.reload.rank).to eq 3
      end
    end

    context "when the winner moves over a single person" do
      it "should update the ranks correctly" do
        MatchObserver.after_save create(:match, winner: p3, loser: p1)

        expect(p1.reload.rank).to eq 1
        expect(p3.reload.rank).to eq 2
        expect(p2.reload.rank).to eq 3
      end
    end

    context "moving halfway to the loser" do
      it "should update intermediary players correctly" do
        Player.update_all :active => true
        Match.update_all :occurred_at => 1.day.ago
        players = Player.all.map{|p|[p.name, p.rank]}
        m = create(:match, winner: p4, loser: p1)
        MatchObserver.after_save m

        expect(p1.reload.rank).to eq 1
        expect(p4.reload.rank).to eq 2
        expect(p2.reload.rank).to eq 3
        expect(p3.reload.rank).to eq 4
      end
    end

    context "when the winner doesn't have a rank yet" do
      it "assigns the correct ranks" do
        Player.update_all :active => true
        MatchObserver.after_save create(:match, winner: p5, loser: p2)

        expect(p2.reload.rank).to eq 2
        expect(p5.reload.rank).to eq 3
        expect(p3.reload.rank).to eq 4
        expect(p4.reload.rank).to eq 5
      end
    end
  end

  describe "marking players inactive" do
    let!(:p1) { Player.create(name: "foo") }
    let!(:p2) { Player.create(name: "bar") }
    let!(:p3) { Player.create(name: "baz") }
    let!(:p4) { Player.create(name: "quux") }
    let!(:m1) { create(:match, winner: p4, loser: p2, occurred_at: 31.days.ago) }
    let!(:m2) { create(:match, winner: p1, loser: p3, occurred_at: 15.days.ago) }

    it "should mark players as inactive who haven't played a game in the last 30 days" do
      Player.update_all :active => true
      expect(p4).to be_active
      MatchObserver.after_save create(:match, winner: p2, loser: p3)
      expect(p1.reload).to be_active
      expect(p2.reload).to be_active
      expect(p3.reload).to be_active
      expect(p4.reload).to be_inactive
    end

    it "should award players who are inactive with Inactive achievement if they don't have it" do
      Player.update_all :active => true
      expect(p4).to be_active
      MatchObserver.after_save create(:match, winner: p2, loser: p3)
      expect(p1.reload).to be_active
      expect(p2.reload).to be_active
      expect(p3.reload).to be_active
      expect(p4.reload).to be_inactive
      expect(p4.achievements.map(&:class)).to include(Inactive)
    end

    it "should mark players as inactive who have never played a game" do
      Player.update_all :active => true
      new_player = Player.create(name: "no matches")
      expect(new_player).to be_active
      MatchObserver.after_save create(:match, winner: p2, loser: p3)
      expect(new_player.reload).to be_inactive
    end

    it "should update other rankings around the newly inactive player" do
      Player.update_all :active => true
      p4.reload.update_attribute :rank, 1
      p2.reload.update_attribute :rank, 2
      p1.reload.update_attribute :rank, 3
      p3.reload.update_attribute :rank, 4

      MatchObserver.after_save create(:match, winner: p4, loser: p3)
      expect(p4.reload.rank).to eq 1
      expect(p2.reload.rank).to be_nil
      expect(p2).to be_inactive
      expect(p1.reload.rank).to eq 2
      expect(p3.reload.rank).to eq 3
    end
  end

  describe "reactivating players" do
    let!(:p1) { Player.create(name: "foo") }
    let!(:p2) { Player.create(name: "bar") }

    before do
      p2.update_attributes(rank: nil, active: false)
    end
    it "should reactivate inactive players when they win a match" do
      create(:match, winner: p1, loser: p2)
      expect(p1.reload).to be_active
    end

    it "should reactivate inactive players when the lose a match" do
      create(:match, winner: p2, loser: p1)
      expect(p1.reload).to be_active
    end
  end
end
