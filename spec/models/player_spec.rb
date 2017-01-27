require 'spec_helper'

describe Player do
  it 'should downcase names' do
    expect(Player.create(name: "Gregg Van Hove").name).to eq('gregg van hove')
  end

  it "should validate unique names" do
    Player.create(name: 'p1')
    p = Player.new(name: 'p1')
    expect(p).to_not be_valid
    expect(p.errors[:name].length).to be(1)
  end

  it "should validate unique ranks" do
    p1 = Player.create(name: 'p1')
    p2 = Player.create(name: 'p2')
    expect(p1.rank).to_not be_nil
    expect(p2.rank).to_not be_nil
    expect(p1.rank).to_not eq p2.rank
  end

  it "requires a name" do
    expect(Player.new).to_not be_valid
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
      expect(Player.active).to eq [me, you]
      expect(Player.inactive).to eq [us]
    end
  end

  describe "#most_recent_match" do
    it "should return the most recent match" do
      player = Player.create(name: "me")
      allow(player).to receive_message_chain(:matches, :descending).and_return [1, 2, 3]
      expect(player.most_recent_match).to eq 1
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
      expect(me.most_recent_opponent).to eq you
      expect(you.most_recent_opponent).to eq me
    end
  end

  describe ".compress_ranks" do
    let!(:p1) { Player.create(name: "p1", rank: 1) }
    let!(:p2) { Player.create(name: "p2", rank: 3) }
    let!(:p3) { Player.create(name: "p3", rank: 5) }
    let!(:p4) { Player.create(name: "p4", rank: 9) }

    it "should leave no gaps in the rankings" do
      Player.compress_ranks

      expect(p1.reload.rank).to eq 1
      expect(p2.reload.rank).to eq 2
      expect(p3.reload.rank).to eq 3
      expect(p4.reload.rank).to eq 4
    end
  end
end
