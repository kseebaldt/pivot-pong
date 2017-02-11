class AchievementsController < ApplicationController
  skip_before_filter :authenticate

  def index
    @achievements = Achievement.subclasses
  end

  def show
    klass = params[:id].split('_').map(&:capitalize).join.constantize
    @achievement = klass
    @achievements = klass.includes(:player).order("created_at desc")
  end
end