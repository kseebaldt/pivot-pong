require 'spec_helper'

describe Player do
  it 'should downcase names' do
    expect(Player.create(name: "Gregg Van Hove").name).to eq('gregg van hove')
  end

  it "should validate unique names" do
    Player.create(name: 'p1')
    p = Player.new(name: 'p1')
    p.should_not be_valid
    p.error_on(:name).should be_present
  end

  it "should validate unique ranks" do
    p1 = Player.create(name: 'p1')
    p2 = Player.create(name: 'p2')
    p1.rank.should_not be_nil
    p2.rank.should_not be_nil
    p1.rank.should_not == p2.rank
  end

  it "requires a name" do
    Player.new.should_not be_valid
  end

  it 'should have a displayable name' do
    expect(Player.create(name: 'scooby doo').display_name).to eq('Scooby Doo')
  end

  describe "ranked" do
    let!(:me) { Player.create(name: "me") }
    let!(:you) { Player.create(name: "you") }
    let!(:us) { Player.create(name: "us") }
    subject { Player.ranked }
    it { should == [me, you, us] }
  end

  describe ".active and .inactive" do
    let!(:me) { Player.create(name: "me") }
    let!(:you) { Player.create(name: "you") }
    let!(:us) { Player.create(name: "us") }

    before do
      us.update_attributes(:rank => nil, :active => false)
    end

    it "should scope players correctly" do
      Player.active.should == [me, you]
      Player.inactive.should == [us]
    end
  end

  describe "#most_recent_match" do
    it "should return the most recent match" do
      player = Player.create(name: "me")
      player.stub_chain(:matches, :descending).and_return [1, 2, 3]
      player.most_recent_match.should == 1
    end
  end

  describe "#matches" do
    let!(:player) { Player.create(name: "me") }
    subject { player.matches }
    let!(:opponent) { Player.create(name: "you") }
    let!(:m1) { Match.create(winner: player, loser: opponent) }
    it { should == [m1] }

    before do
      Match.update_all :occured_at => 1.day.ago
    end
    context "multiple matches" do
      let!(:m2) { Match.create(winner: opponent, loser: player) }
      it { should == [m1, m2] }

      context "with retro-actively created matches" do
        let!(:m3) { Match.create(winner: player, loser: opponent, occured_at: 1.day.ago) }
        it { should == [m1, m2] }
      end
    end
  end

  describe "#most_recent_opponent" do
    it "should return the most recent opponent" do
      me = Player.create(name: "me")
      you = Player.create(name: "you")
      Match.create(winner: me, loser: you)
      me.most_recent_opponent.should == you
      you.most_recent_opponent.should == me
    end
  end

  describe ".compress_ranks" do
    let!(:p1) { Player.create(name: "p1", rank: 1) }
    let!(:p2) { Player.create(name: "p2", rank: 3) }
    let!(:p3) { Player.create(name: "p3", rank: 5) }
    let!(:p4) { Player.create(name: "p4", rank: 9) }

    it "should leave no gaps in the rankings" do
      Player.compress_ranks

      p1.reload.rank.should == 1
      p2.reload.rank.should == 2
      p3.reload.rank.should == 3
      p4.reload.rank.should == 4
    end
  end
end
