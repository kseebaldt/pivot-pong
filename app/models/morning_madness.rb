class MorningMadness < Achievement
  class << self
    def title
      "Morning Madness"
    end

    def description
      "Log a match before 9am PST"
    end

    def badge
      "fa fa-adjust"
    end

    def eligible?(player)
      match = player.most_recent_match
      (match.occurred_at > Time.current.beginning_of_day) && (match.occurred_at.hour < 9)
    end
  end
end