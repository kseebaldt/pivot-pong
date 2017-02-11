class Achievement < ActiveRecord::Base
  belongs_to :player
  belongs_to :match

  validates :player_id, presence: true
  validates :type, presence: true

  scope :from_player, ->(player) { where(player_id: player.id) }

  class << self
    def title
      raise "Must be implemented in subclasses"
    end

    def description
      raise "Must be implemented in subclasses"
    end

    def badge
      raise "Must be implemented in subclasses"
    end

    def eligible?(player)
      raise "Must be implemented in subclasses"
    end

    def slug
      self.class.to_s.underscore
    end
  end

  def title
    self.class.title
  end

  def description
    self.class.description
  end

  def badge
    self.class.badge
  end

  def slug
    self.class.slug
  end
end
