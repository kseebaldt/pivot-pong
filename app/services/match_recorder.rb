module MatchRecorder
  def self.record(winner:, loser:, occurred_at:)
    if winner == '' || loser == ''
      return 'Must specify a winner and a loser to post a match.'
    end

    if occurred_at.nil? || occurred_at == ''
      occurred_at = Time.current
    end

    winning_player = get_player(winner)
    losing_player = get_player(loser)

    match = Match.create(winner: winning_player, loser: losing_player, occurred_at: occurred_at)
    if match.valid?
      MatchObserver.after_save(match)
      nil
    else
      match.errors.full_messages.join("\n")
    end
  end

  class << self
    private

    def get_player(name)
      name = name.strip
      player = Player.lookup(name)
      player = Player.create!(name: name) unless player
      player
    end
  end
end