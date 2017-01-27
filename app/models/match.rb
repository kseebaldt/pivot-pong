class Match < ActiveRecord::Base
  validates :winner,      presence: true
  validates :loser,       presence: true
  validates :occured_at,  presence: true
  validate :daily_limit, on: :create

  belongs_to :winner, :class_name => 'Player'
  belongs_to :loser, :class_name => 'Player'

  has_many :achievements

  before_validation :set_default_occured_at_date, on: :create

  scope :occurred_today, lambda { |time| where("occured_at >= ? AND occured_at <= ?", time.beginning_of_day, time.end_of_day) }
  scope :descending, lambda { order("occured_at DESC") }

  private

  def set_default_occured_at_date
    self.occured_at ||= Time.current
  end

  def daily_limit
    winner_id = self.winner_id
    loser_id = self.loser_id
    played_today = Match.where(winner_id: winner_id, loser_id: loser_id).occurred_today(occured_at).present? || Match.where(winner_id: loser_id, loser_id: winner_id).occurred_today(occured_at).present?
    (errors[:bad_match] << "- Already played today!") if played_today
  end
end
