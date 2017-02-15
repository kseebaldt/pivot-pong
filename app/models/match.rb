class Match < ActiveRecord::Base
  validates :winner, presence: true
  validates :loser, presence: true
  validates :occurred_at, presence: { message: "must be a valid date or time." }
  validate :daily_limit, on: :create
  validate :non_future, on: [:create, :update]

  belongs_to :winner, :class_name => 'Player'
  belongs_to :loser, :class_name => 'Player'

  has_many :achievements

  scope :occurred_today, lambda { |time| where("occurred_at >= ? AND occurred_at <= ?", time.beginning_of_day, time.end_of_day) }
  scope :descending, lambda { order("occurred_at DESC") }

  private

  def daily_limit
    return unless occurred_at

    winner_id = self.winner_id
    loser_id = self.loser_id
    played_today = Match.where(winner_id: winner_id, loser_id: loser_id).occurred_today(occurred_at).present? || Match.where(winner_id: loser_id, loser_id: winner_id).occurred_today(occurred_at).present?
    (errors[:bad_match] << "- Already played today!") if played_today
  end

  def non_future
    return unless occurred_at

    (errors[:occurred_at] << "cannot be in the future.") if occurred_at > Time.current
  end
end
