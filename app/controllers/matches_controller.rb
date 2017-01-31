class MatchesController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: :create
  skip_before_filter :authenticate, only: [:show, :players]

  include MatchesHelper

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

    redirect_to matches_path(d: true)
  end

  def destroy
    Match.find(params[:id]).destroy
    redirect_to matches_path
  end

  def index
    @match = Match.new
    @matches = Match.paginate(:page => params[:page]).order("occured_at DESC")
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
      queryStart = params[:q].downcase + '%'
      queryMid = '% ' + params[:q].downcase + '%'
      names = Player.where(['LOWER(name) LIKE ? OR LOWER(name) LIKE ?', queryStart, queryMid]).collect(&:name)
    else
      names = Player.all.collect(&:name)
    end

    render text: names.sort.uniq.join("\n")
  end
end
