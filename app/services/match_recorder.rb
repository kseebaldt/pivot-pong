module MatchRecorder
  def self.record(winner:, loser:, occurred_at:)
    if occurred_at.nil? || occurred_at == ''
      occurred_at = Time.current
    end

    begin
      Match.transaction do
        winning_player = get_player(winner)
        losing_player = get_player(loser)

        match = Match.create!(winner: winning_player, loser: losing_player, occurred_at: occurred_at)
        MatchObserver.after_save(match)
        return nil
      end
    rescue ActiveRecord::RecordInvalid => invalid
      return invalid.message.sub('Validation failed: ', '')
    end
  end

  def self.update(match:, winner:, loser:, occurred_at:)
    if occurred_at.nil? || occurred_at == ''
      occurred_at = match.occurred_at
    end

    begin
      Match.transaction do
        winning_player = get_player(winner)
        losing_player = get_player(loser)

        match.update_attributes!(winner: winning_player, loser: losing_player, occurred_at: occurred_at)
        MatchObserver.after_save(match)
        return nil
      end
    rescue ActiveRecord::RecordInvalid => invalid
      return invalid.message.sub('Validation failed: ', '')
    end
  end

  class << self
    private

    def get_player(name)
      name = name.strip
      player = Player.lookup(name)
      player = Player.create(name: name) unless player
      player.valid? ? player : nil
    end
  end
end