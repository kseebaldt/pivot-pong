class HeartYou < Achievement
  class << self
    def title
      "I Heart You"
    end

    def description
      "Last 3 logged matches were with the same person"
    end

    def badge
      "fa fa-heart"
    end

    def eligible?(player)
      last_3_matches = player.matches.descending.limit(3)
      return false if last_3_matches.size < 3

      unique_players = Set.new []
      last_3_matches.each do |match|
        unique_players.add(match.winner)
        unique_players.add(match.loser)
      end
      return unique_players.size == 2
    end
  end

  def description
    opponent = match.winner == player ? match.loser.name : match.winner.name
    "Last 3 logged matches were with #{opponent}"
  end
end