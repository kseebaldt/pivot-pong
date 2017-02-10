class Inactive < Achievement
  def title
    "Where'd You Go?"
  end

  def description
    "Gone inactive after 30 days of not playing"
  end

  def badge
    "fa fa-minus-circle"
  end

  class << self
    def eligible?(player)
      false # will be awarded when players are marked as inactive
    end
  end
end