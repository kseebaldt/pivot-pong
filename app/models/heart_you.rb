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
      previous_match = player.most_recent_match
      players = [previous_match.winner, previous_match.loser]
      players.delete(player)
      opponent = players.first
      last_3_matches = player.matches.descending.limit(3)
      return false if last_3_matches.size < 3
      last_3_matches.each{|match| return false if ![match.winner, match.loser].include?(opponent) }
      true
    end
  end
end