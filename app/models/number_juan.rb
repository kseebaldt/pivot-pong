class NumberJuan < Achievement
  def title
    "Number Juan"
  end

  def description
    "Dos no es un ganador y tres nadie recuerda"
  end

  def badge
    "fa fa-trophy"
  end

  class << self
    def eligible?(player)
      player.rank == 1
    end
  end
end