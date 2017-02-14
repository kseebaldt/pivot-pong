class OverlyAttached < Achievement
  class << self
    def title
      "Overly Attached"
    end

    def description
      "Last 6 matches were with the same person"
    end

    def badge
      "fa fa-magnet"
    end

    def eligible?(player)
      last_6_matches = player.matches.descending.limit(6)
      return false if last_6_matches.size < 6

      unique_players = Set.new []
      last_6_matches.each do |match|
        unique_players.add(match.winner)
        unique_players.add(match.loser)
      end
      return unique_players.size == 2
    end
  end

  def description
    opponent = match.winner == player ? match.loser.name : match.winner.name
    "Last 6 matches were with #{opponent}"
  end
end