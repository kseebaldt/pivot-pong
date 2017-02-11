class Beginner < Achievement
  class << self
    def title
      "Beginner"
    end

    def description
      "Welcome to the wonderful game of pong"
    end

    def badge
      "fa fa-check"
    end

    def eligible?(player)
      true
    end
  end
end