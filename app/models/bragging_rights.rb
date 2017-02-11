class BraggingRights < Achievement
  class << self
    def title
      "Bragging Rights"
    end

    def description
      "Tweet Your Victory"
    end

    def badge
      "fa fa-twitter"
    end

    def eligible?(player)
      false
    end
  end
end