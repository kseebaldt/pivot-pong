class BraggingRights < Achievement
  def title
    "Bragging Rights"
  end

  def description
    "Tweet Your Victory"
  end

  def badge
    "fa fa-twitter"
  end

  class << self
    def eligible?(player)
      false
    end
  end
end