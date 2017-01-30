include ActionView::Helpers::NumberHelper

class StatsController < ApplicationController
  skip_before_filter :authenticate

  def index
    @matches_labels = []
    @matches_values = []
    @winning_matches_labels = []
    @winning_matches = []
    @winning_percentage_labels = []
    @winning_percentage = []
    games_hash = Match.group("DATE(occured_at)").count
    @average_games_per_day = games_hash.values.sum.to_f/games_hash.keys.count.to_f
    Player.all.each do |p|
      match_count = p.matches.count
      winning_match_count = p.winning_matches.count
      winning_percentage = winning_match_count.to_f/match_count.to_f*100

      @matches_labels << "#{p.display_name} - #{match_count}"
      @matches_values << match_count

      @winning_matches_labels << "#{p.display_name} - #{winning_match_count}"
      @winning_matches << winning_match_count

      @winning_percentage_labels << "#{p.display_name} - #{number_to_percentage(winning_percentage)}"
      @winning_percentage << winning_percentage
    end
  end
end