class Log < ActiveRecord::Base
  belongs_to :player
  belongs_to :match

  validates :rank, presence: true
  validates :player_id, presence: true
  validates :match_id, presence: true
  validate :check_for_occurred_at

  scope :descending, lambda { order("occurred_at DESC") }

  private

  def check_for_occurred_at
    if self.occurred_at.blank?
      self.occurred_at = Time.current
    end
  end
end