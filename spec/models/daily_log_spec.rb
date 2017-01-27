require 'spec_helper'

describe DailyLog do
  describe ".create" do
    let(:me) { Player.create(name: 'me') }
    let(:you) { Player.create(name: 'you') }

    it "should aggregate" do
      Match.create(winner: me, loser: you)
      daily_log = DailyLog.create
      expect(daily_log).to be_valid
      expect(daily_log.average_games_per_player).to eq 0.5
      expect(daily_log.match_count).to eq 1
      expect(daily_log.date).to eq Date.today
    end
  end
end
