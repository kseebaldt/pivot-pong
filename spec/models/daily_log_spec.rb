require 'rails_helper'

describe DailyLog do
  describe ".create" do
    let(:me) { Player.create(name: 'me') }
    let(:you) { Player.create(name: 'you') }

    it "should aggregate logs early in the day" do
      Timecop.freeze('2013-01-02T23:59:00.000Z') do
        create(:match, winner: me, loser: you)
        daily_log = DailyLog.create
        expect(daily_log).to be_valid
        expect(daily_log.average_games_per_player).to eq 0.5
        expect(daily_log.match_count).to eq 1
        expect(daily_log.date).to eq Date.today
      end
    end

    it "should aggregate logs late in the day" do
      Timecop.freeze('2013-01-03T00:01:00.000Z') do
        create(:match, winner: me, loser: you)
        daily_log = DailyLog.create
        expect(daily_log).to be_valid
        expect(daily_log.average_games_per_player).to eq 0.5
        expect(daily_log.match_count).to eq 1
        expect(daily_log.date).to eq Date.today
      end
    end
  end
end
