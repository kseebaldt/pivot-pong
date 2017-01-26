require 'spec_helper'

describe MatchObserver do
  let(:me) { Player.create(name: 'me') }
  let(:you) { Player.create(name: 'you') }
  let(:observer) { MatchObserver.instance }
  let(:match) { Match.new(winner: you, loser: me, occured_at: Time.current) }

  describe "#after_save" do
    it "should make the appropriate method calls" do
      observer.should_receive(:update_player_ranks)
      observer.should_receive(:create_logs)
      observer.should_receive(:check_achievements)
      observer.should_receive(:check_totems)
      observer.should_receive(:mark_inactive_players)
      observer.after_save(match)
    end
  end

  describe "#update_player_ranks" do
    it "updates rank appropriately based on match entered" do
      me.rank.should == 1
      you.rank.should == 2
      observer.send(:update_player_ranks, match)
      you.reload.rank.should == 1
      me.reload.rank.should == 2
    end

    it "make the loser active and ranked if they are inactive" do
      me.update_attributes(active: false, rank: nil)
      you.update_attributes(rank: 1)
      me.should_not be_active
      observer.send(:update_player_ranks, match)
      you.rank.should == 1
      me.rank.should == 2
      me.should be_active
    end
  end

  describe "#create_logs" do
    it "should create log from last match" do
      expect { match.save! }.to change(Log, :count).by(2)
    end
  end

  describe "#check_achievements" do
    it "should check and award achievements of both players" do
      Beginner.should_receive(:create).at_least(:once)
      me.achievements.count.should == 0
      you.achievements.count.should == 0
      Match.create(winner: me, loser: you)
      me.achievements.count.should > 0
      you.achievements.count.should > 0
    end
  end

  describe "#check_totems" do
    it "should award a totem if winner does not own yet" do
      me.totems.count.should == 0
      you.totems.count.should == 0
      Match.create(winner: me, loser: you)
      me.reload.totems.count.should == 1
      you.reload.totems.count.should == 0
    end

    it "should not award a totem if winner already owns" do
      me.totems.create(loser: you)
      me.reload.totems.count.should == 1
      you.reload.totems.count.should == 0
      Match.create(winner: me, loser: you)
      me.reload.totems.count.should == 1
      you.reload.totems.count.should == 0
    end

    it "should remove totem from winner loser beats them" do
      me.totems.create(loser: you)
      me.reload.totems.count.should == 1
      you.reload.totems.count.should == 0
      Match.create(winner: you, loser: me)
      me.reload.totems.count.should == 0
      you.reload.totems.count.should == 1
    end
  end

  describe "#mark_inactive_players" do
    it "clears ranks when players become inactive" do
      me.should be_active
      me.rank.should == 1
      observer.send(:mark_inactive_players)
      me.reload.should be_inactive
      me.rank.should be_nil
    end
  end
end
