class SameShtDifferentDay < Achievement
  class << self
    def title
      "Same Sh*t, Different Day"
    end

    def description
      "Stay the same rank 7 matches in a row"
    end

    def badge
      "fa fa-lock"
    end

    def eligible?(player)
      last_7_logs = player.logs.descending.limit(7)
      return false if last_7_logs.size < 7 || (last_7_logs.map(&:rank).uniq.size > 1)
      true
    end
  end
end