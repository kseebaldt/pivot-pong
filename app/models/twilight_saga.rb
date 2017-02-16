class TwilightSaga < Achievement
  class << self
    def title
      "Twilight Saga"
    end

    def description
      "Log a match after 6pm PST"
    end

    def badge
      "fa fa-clock-o"
    end

    def eligible?(player)
      match = player.most_recent_match
      (match.occurred_at > Time.current.beginning_of_day + 18.hours) && (match.occurred_at < Time.current.end_of_day)
    end
  end
end