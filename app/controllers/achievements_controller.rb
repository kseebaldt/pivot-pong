class AchievementsController < ApplicationController
  skip_before_filter :authenticate

  @achiever = Player.new(name: 'Achiever')
  @match = Match.new(winner: @achiever, loser: Player.new(name: 'Opponent'), occurred_at: '1969-7-20')

  def index
    @achievements = []
    Achievement.subclasses.each do |klass|
      @achievements << klass.new(player: @achiever, match: @match)
    end
  end

  def show
    klass = params[:id].split('_').map(&:capitalize).join.constantize
    @achievement = klass.new(player: @achiever, match: @match)
    @achievements = klass.includes(:player).order("created_at desc")
  end
end