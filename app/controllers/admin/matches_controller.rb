class Admin::MatchesController < Admin::BaseController
  def index
    @matches = Match.paginate(:page => params[:page]).order("occurred_at DESC")
  end

  def new
    @match = Match.new
  end

  def edit
    @match = Match.find params[:id]
  end

  def update
    @match = Match.find params[:id]
    occurred_at = params.fetch(:match, {}).fetch(:occurred_at, @match.occurred_at)
    error_message = MatchRecorder.update(match: @match, winner: params[:winner_name], loser: params[:loser_name], occurred_at: occurred_at)

    if error_message
      flash.alert = error_message
      render :edit and return
    end

    redirect_to admin_matches_path
  end

  def create
    occurred_at = params.fetch(:match, {})[:occurred_at]
    error_message = MatchRecorder.record winner: params[:winner_name], loser: params[:loser_name], occurred_at: occurred_at

    if error_message
      flash.alert = error_message
    end

    redirect_to admin_matches_path
  end

  def destroy
    if Match.find(params[:id]).destroy
      flash.notice = "Match successfully deleted"
      redirect_to admin_matches_path
    else
      flash.alert = "There was an error deleting your match"
      redirect_to admin_matches_path
    end
  end
end
