class Streak < Achievement
  def title
    "You're on a Streak!"
  end

  def description
    "Win 5 matches in a row"
  end

  def badge
    "fa fa-fire"
  end

  class << self
    def eligible?(player)
      last_matches = player.matches.descending.limit(5)
      return false if last_matches.count < 5
      last_matches.each { |match| return false if match.winner != player }
      true
    end
  end
end