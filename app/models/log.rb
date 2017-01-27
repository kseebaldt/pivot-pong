class Log < ActiveRecord::Base
  belongs_to :player
  belongs_to :match

  validates :rank, presence: true
  validates :player_id, presence: true
  validates :match_id, presence: true
  validate :check_for_occured_at

  scope :descending, lambda { order("occured_at DESC") }

  private

  def check_for_occured_at
    if self.occured_at.blank?
      self.occured_at = Time.current
    end
  end
end