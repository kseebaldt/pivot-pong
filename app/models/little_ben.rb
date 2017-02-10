class LittleBen < Achievement
  def title
    "Little Ben!"
  end

  def description
    "Played more than 50 matches"
  end

  def badge
    "fa fa-tag"
  end

  class << self
    def eligible?(player)
      player.matches.descending.limit(50).size > 49
    end
  end
end