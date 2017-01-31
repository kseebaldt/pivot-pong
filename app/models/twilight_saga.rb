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
      (match.occured_at > Date.today.beginning_of_day + 18.hours) && (match.occured_at < Date.today.end_of_day)
    end
  end
end