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
      previous_match = player.most_recent_match
      players = [previous_match.winner, previous_match.loser]
      players.delete(player)
      opponent = players.first
      last_6_matches = player.matches.descending.limit(6)
      return false if last_6_matches.size < 6
      last_6_matches.each{|match| return false if ![match.winner, match.loser].include?(opponent) }
      true
    end
  end
end