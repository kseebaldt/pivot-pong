require 'rails_helper'

describe StatsController do
  describe "display average games per day" do
    let(:me) { Player.create(name: 'Me') }
    let(:you) { Player.create(name: 'You') }
    it "GET index" do
      create(:match, winner: me, loser: you)
      get :index
      expect(assigns(:average_games_per_day)).to eq 1
      expect(assigns(:matches_labels).sort).to eq ['Me - 1','You - 1']
      expect(assigns(:matches_values)).to eq [1,1]
      expect(assigns(:winning_matches_labels).sort).to eq ['Me - 1','You - 0']
      expect(assigns(:winning_matches)).to eq [1,0]
      expect(assigns(:winning_percentage_labels).sort).to eq ['Me - 100.000%','You - 0.000%']
      expect(assigns(:winning_percentage)).to eq [100.000,0.000]
    end
  end
end
