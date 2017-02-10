class HeadHunter < Achievement
  def title
    "Head Hunter"
  end

  def description
    "Accumulate 10 or more totems for your totem pole"
  end

  def badge
    "fa fa-user"
  end

  class << self
    def eligible?(player)
      player.totems.count > 9
    end
  end
end