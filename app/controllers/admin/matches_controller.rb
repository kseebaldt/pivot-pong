class Admin::MatchesController < Admin::BaseController
  include MatchesHelper

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
    winner, loser = params.values_at(:winner_name, :loser_name).map { |name|
      Player.find_or_create_by(name: name.strip.downcase)
    }
    occured_at = params[:match].present? ? params[:match][:occured_at] : Time.current
    if @match.update_attributes winner: winner, loser: loser, occured_at: occured_at
      MatchObserver.new.after_save @match
      flash.notice = "Match successfully updated"
      redirect_to admin_matches_path
    else
      flash.alert = @match.errors.full_messages.join(', ')
      render :edit
    end
  end

  def create
    winner, loser = params.values_at(:winner_name, :loser_name).map { |name|
      Player.find_or_create_by(name: name.strip.downcase)
    }

    occured_at = params[:match].present? ? params[:match][:occured_at] : Time.current
    match = Match.new winner: winner, loser: loser, occured_at: occured_at

    if [winner, loser].all?(&:valid?) && match.save
      MatchObserver.new.after_save match
    else
      if match.errors.present?
        flash.alert = match.errors.full_messages.join('\n')
      else
        flash.alert = "Must specify a winner and a loser to post a match."
      end
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
