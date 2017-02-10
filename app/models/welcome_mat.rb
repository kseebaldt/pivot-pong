class WelcomeMat < Achievement
  def title
    "Laying Out the Welcome Mat"
  end

  def description
    "Play someone not on the ladder"
  end

  def badge
    "fa fa-plus"
  end

  class << self
    def eligible?(player)
      player.most_recent_opponent.matches.size == 1
    end
  end
end