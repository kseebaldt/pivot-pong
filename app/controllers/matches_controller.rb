class MatchesController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: :create
  skip_before_filter :authenticate, only: [:show, :players]

  def create
    occurred_at = params.fetch(:match, {})[:occurred_at]
    error_message = MatchRecorder.record winner: params[:winner_name], loser: params[:loser_name], occurred_at: occurred_at

    if error_message
      flash.alert = error_message
      redirect_to matches_path and return
    end

    redirect_to matches_path(d: true)
  end

  def destroy
    Match.find(params[:id]).destroy
    redirect_to matches_path
  end

  def index
    @match = Match.new
    @matches = Match.paginate(:page => params[:page]).order("occurred_at DESC")
    @most_recent_match = Match.find_by_id(params[:d]) || @matches.first if params[:d]
  end

  def show
    @match = Match.find(params[:id])
    @winner = @match.winner
    @loser = @match.loser
  end

  def rankings
    @rankings = Player.active.ranked
  end

  def players
    if params[:q]
      names = Player.search(params[:q]).collect(&:name)
    else
      names = Player.all.collect(&:name)
    end

    render text: names.sort.uniq.join("\n")
  end
end
