class MorningMadness < Achievement
  def title
    "Morning Madness"
  end

  def description
    "Log a match before 9am PST"
  end

  def badge
    "fa fa-adjust"
  end

  class << self
    def eligible?(player)
      match = player.most_recent_match
      (match.occurred_at > Date.today.beginning_of_day) && (match.occurred_at.hour < 9)
    end
  end
end