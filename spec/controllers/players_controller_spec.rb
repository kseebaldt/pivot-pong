require 'rails_helper'

describe PlayersController do
  let(:me) { Player.create(name: "me") }
  let(:you) { Player.create(name: "you") }
  let(:him) { Player.create(name: "him") }

  describe "GET #show" do
    before do
      create(:match, winner: me, loser: you)
    end

    it "should load the correct player" do
      get :show, id: me.to_param
      expect(assigns(:player)).to eq me
      expect(assigns(:matches)).to eq me.matches.paginate(:page => 1).order("occurred_at DESC")
      expect(assigns(:average_games_per_day)).to eq 1
      expect(response).to be_success
    end

    it "should load the achievement if set" do
      achievement = me.achievements.first
      get :show, id: me.to_param, a: achievement.to_param
      expect(assigns(:achievement)).to eq achievement
    end
  end

  describe "#odds" do
    it "should render probability base off of existing matches if they exist" do
      create(:match, winner: me, loser: you, occurred_at: 1.day.ago)
      create(:match, winner: you, loser: me)
      matches = me.matches.where("winner_id = ? OR loser_id = ?", you.id, you.id)
      expect(matches.count).to eq 2
      get :odds, player_id: me.id, opponent_id: you.id
      expect(response.body).to eq '50.0'
    end

    it "should render 50 if winner rank and loser rank is nil" do
      me.update_attribute(:rank, nil)
      you.update_attribute(:rank, nil)
      get :odds, player_id: me.id, opponent_id: you.id
      expect(response.body).to eq '50'
    end

    it "should render 0 if winner rank is nil and lose rank is not" do
      me.update_attribute(:rank, nil)
      get :odds, player_id: me.id, opponent_id: you.id
      expect(response.body).to eq '0'
    end

    it "should render 100 if winner rank is not nil and loser rank is" do
      you.update_attribute(:rank, nil)
      get :odds, player_id: me.id, opponent_id: you.id
      expect(response.body).to eq '100'
    end
  end
end
