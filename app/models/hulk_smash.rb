class HulkSmash < Achievement
  class << self
    def title
      "Hulk Smash"
    end

    def description
      "Overall win record vs. someone spreads 10 or more"
    end

    def badge
      "fa fa-legal"
    end

    def eligible?(player)
      previous_match = player.most_recent_match
      winner_id = previous_match.winner.id
      loser_id = previous_match.loser.id
      return false if winner_id != player.id
      matches = Match.where(winner_id: [winner_id, loser_id], loser_id: [winner_id, loser_id])
      player_wins = matches.where(winner_id: winner_id).count
      opponent_wins = matches.where(winner_id: loser_id).count
      (player_wins - opponent_wins) > 9
    end
  end
end