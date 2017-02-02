class MatchObserver
  def self.after_save(match)
    observer = new(match)

    observer.after_save
  end

  def initialize(match)
    @match = match
  end

  def after_save
    update_player_ranks
    create_logs
    check_achievements
    check_totems
    mark_inactive_players
  end

  private

  attr_reader :match

  def update_player_ranks
    winner = match.winner
    winner_rank = winner.rank || Player.maximum(:rank) + 1
    loser = match.loser
    loser_rank = loser.rank || Player.maximum(:rank) + 1

    if winner_rank > loser_rank
      new_rank = (winner_rank + loser_rank) / 2
      winner.update_attributes(rank: nil)
      Player.where(['rank < ? AND rank >= ?', winner_rank, new_rank]).order('rank desc').each do |player|
        player.update_attributes(rank: player.rank + 1)
      end
      winner.update_attributes(rank: new_rank, active: true)
    else
      winner.update_attributes(active: true)
    end
    loser.update_attributes(rank: loser_rank, active: true) if !loser.active?
  end

  def create_logs
    winner = match.winner
    loser = match.loser
    winner.logs.create(match: match, rank: winner.rank)
    loser.logs.create(match: match, rank: loser.rank)
  end

  def check_achievements
    winner = match.winner
    loser = match.loser
    achievements = Achievement.subclasses
    winner_achievements_needed = achievements - winner.achievements.map(&:class)
    loser_achievements_needed = achievements - loser.achievements.map(&:class)
    winner_achievements_needed.each do |achievement|
      if achievement.eligible?(winner)
        achievement.create(player: winner, match: match)
      end
    end
    loser_achievements_needed.each do |achievement|
      achievement.create(player: loser, match: match) if achievement.eligible?(loser)
    end
  end

  def check_totems
    winner = match.winner
    loser = match.loser
    winner.totems.find_or_create_by(loser_id: loser.id)
    loser.totems.where(loser_id: winner.id).destroy_all
  end

  def mark_inactive_players
    cutoff = 30.days.ago
    Player.active.each do |player|
      if player.most_recent_match.nil? || (player.most_recent_match.occured_at < cutoff)
        player.update_attributes! :active => false
        Inactive.create(player: player) if !player.achievements.map(&:class).include?(Inactive)
      end
    end

    Player.compress_ranks
  end
end
