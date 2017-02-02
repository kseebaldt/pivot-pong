require 'rails_helper'

describe MatchObserver do
  let(:me) { Player.create!(name: 'me') }
  let(:you) { Player.create!(name: 'you') }
  let(:observer) { MatchObserver.new(match) }
  let(:match) { Match.new(winner: you, loser: me, occured_at: Time.current) }

  describe "#after_save" do
    it "should make the appropriate method calls" do
      expect(observer).to receive(:update_player_ranks)
      expect(observer).to receive(:create_logs)
      expect(observer).to receive(:check_achievements)
      expect(observer).to receive(:check_totems)
      expect(observer).to receive(:mark_inactive_players)
      observer.after_save
    end
  end

  describe "#update_player_ranks" do
    it "updates rank appropriately based on match entered" do
      expect(me.rank).to eq 1
      expect(you.rank).to eq 2
      observer.send(:update_player_ranks)
      expect(you.reload.rank).to eq 1
      expect(me.reload.rank).to eq 2
    end

    it "make the loser active and ranked if they are inactive" do
      me.update_attributes(active: false, rank: nil)
      you.update_attributes(rank: 1)
      expect(me).to_not be_active
      observer.send(:update_player_ranks)
      expect(you.rank).to eq 1
      expect(me.rank).to eq 2
      expect(me).to be_active
    end
  end

  describe "#create_logs" do
    it "should create log from last match" do
      expect do
        match.save!
        observer.send(:create_logs)
      end.to change(Log, :count).by(2)
    end
  end

  describe "#check_achievements" do
    it "should check and award achievements of both players" do
      expect(Beginner).to receive(:create).at_least(:once)
      expect(me.achievements.count).to eq 0
      expect(you.achievements.count).to eq 0
      match.save!
      observer.send(:check_achievements)
      expect(me.achievements.count).to be > 0
      expect(you.achievements.count).to be > 0
    end
  end

  describe "#check_totems" do
    it "should award a totem if winner does not own yet" do
      expect(me.totems.count).to eq 0
      expect(you.totems.count).to eq 0
      match.save!
      observer.send(:check_totems)
      expect(you.reload.totems.count).to eq 1
      expect(me.reload.totems.count).to eq 0
    end

    it "should not award a totem if winner already owns" do
      me.totems.create(loser: you)
      expect(me.reload.totems.count).to eq 1
      expect(you.reload.totems.count).to eq 0
      match.save!
      observer.send(:check_totems)
      expect(you.reload.totems.count).to eq 1
      expect(me.reload.totems.count).to eq 0
    end

    it "should remove totem from winner loser beats them" do
      me.totems.create(loser: you)
      expect(me.reload.totems.count).to eq 1
      expect(you.reload.totems.count).to eq 0
      match.save!
      observer.send(:check_totems)
      expect(me.reload.totems.count).to eq 0
      expect(you.reload.totems.count).to eq 1
    end
  end

  describe "#mark_inactive_players" do
    it "clears ranks when players become inactive" do
      expect(me).to be_active
      expect(me.rank).to eq 1
      observer.send(:mark_inactive_players)
      expect(me.reload).to be_inactive
      expect(me.rank).to be_nil
    end
  end
end
