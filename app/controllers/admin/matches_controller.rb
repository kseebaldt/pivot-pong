class Admin::MatchesController < Admin::BaseController
  def index
    @matches = Match.paginate(:page => params[:page]).order("occured_at DESC")
  end

  def new
    @match = Match.new
  end

  def edit
    @match = Match.find params[:id]
  end

  def update
    @match = Match.find params[:id]
    winner = Player.lookup(params[:winner_name])
    loser = Player.lookup(params[:loser_name])
    occured_at = params.fetch(:match, {}).fetch(:occured_at, @match.occured_at)

    if @match.update_attributes winner: winner, loser: loser, occured_at: occured_at
      MatchObserver.after_save @match
      flash.notice = "Match successfully updated"
      redirect_to admin_matches_path
    else
      flash.alert = @match.errors.full_messages.join(', ')
      render :edit
    end
  end

  def create
    occurred_at = params.fetch(:match, {})[:occured_at]
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
