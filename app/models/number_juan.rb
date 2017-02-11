class NumberJuan < Achievement
  class << self
    def title
      "Number Juan"
    end

    def description
      "Dos no es un ganador y tres nadie recuerda"
    end

    def badge
      "fa fa-trophy"
    end

    def eligible?(player)
      player.rank == 1
    end
  end
end