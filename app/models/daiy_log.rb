class DailyLog < ActiveRecord::Base
  before_create :populate_stats

  private

  def populate_stats
    self.average_games_per_player = Match.count.to_f/Player.count.to_f
    today = Time.current.to_date
    self.match_count = Match.where("occured_at > ? AND occured_at < ?", today.beginning_of_day, today.end_of_day).count
    self.date = Date.today
  end
end