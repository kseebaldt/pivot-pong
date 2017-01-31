class LongJump < Achievement
  class << self
    def title
      "Long Jump"
    end

    def description
      "Advances more than 3 spots in rank from a single match"
    end

    def badge
      "fa fa-long-arrow-up"
    end

    def eligible?(player)
      logs = player.logs.descending.limit(2)
      return false if logs.size != 2
      recent_rank, previous_rank = logs.map(&:rank)
      return false if (previous_rank - recent_rank) < 4
      true
    end
  end
end