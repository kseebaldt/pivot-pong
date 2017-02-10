class BigBen < Achievement
  def title
    "Big Ben!"
  end

  def description
    "Played more than 100 matches"
  end

  def badge
    "fa fa-tags"
  end

  class << self
    def eligible?(player)
      player.matches.limit(100).size > 99
    end
  end
end