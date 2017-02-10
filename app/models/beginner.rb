class Beginner < Achievement
  def title
    "Beginner"
  end

  def description
    "Welcome to the wonderful game of pong"
  end

  def badge
    "fa fa-check"
  end

  class << self
    def eligible?(player)
      true
    end
  end
end