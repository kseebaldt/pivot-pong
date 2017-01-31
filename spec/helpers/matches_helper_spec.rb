require 'spec_helper'

describe MatchesHelper do
  describe "calculating ranking" do
    subject { helper.calculate_rankings(matches) }

    context "no matches passed in" do
      let(:matches) { [] }
      it { should == [] }
    end

    context "one match passed in" do
      let(:matches) { [Match.create(winner: Player.create(name: 'Me'), loser: Player.create(name: 'you'))] }
      it { should == ["Me", "you"] }
    end

    context "multiple matches" do
      let(:matches) do
        p1 = Player.create(name: 'P1')
        p2 = Player.create(name: 'P2')
        [
          Match.create(winner: p1, loser: p2),
          Match.create(winner: p2, loser: p1)
        ]
      end
      it { should == ["P2", "P1"] }
    end

    context "moving halfway to the loser" do
      let(:matches) do
        p1 = Player.create(name: 'P1')
        p2 = Player.create(name: 'P2')
        p3 = Player.create(name: 'P3')
        p4 = Player.create(name: 'P4')
        p1.update_attribute(:rank, 1)
        p2.update_attribute(:rank, 3)
        p3.update_attribute(:rank, 4)
        p4.update_attribute(:rank, 2)
        [
          Match.create(winner: p1, loser: p2),
          Match.create(winner: p2, loser: p3),
          Match.create(winner: p4, loser: p1)
        ]
      end
      it { should == ["P1", "P4", "P2", "P3"] }
    end

    it "preserves entered case in rankings" do
      joe = Player.create(name: 'joe Blow', rank: 1)
      jane = Player.create(name: 'Jane doe', rank: 2)
      spot = Player.create(name: 'spOt', rank: 3)

      matches = [Match.create(winner: joe, loser: jane), Match.create(winner: joe, loser: spot)]
      expect(helper.calculate_rankings(matches)).to eq ["joe Blow", "Jane doe", "spOt"]
    end
  end
end

