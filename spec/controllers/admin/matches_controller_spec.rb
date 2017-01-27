require 'spec_helper'

describe Admin::MatchesController do
  let!(:p1) { Player.create name: 'me' }
  let!(:p2) { Player.create name: 'you' }

  describe "#index" do
    before { get :index }

    it 'shows the matches' do
      expect(response).to be_success
      expect(assigns(:matches)).to eq Match.all
    end
  end

  describe "#new" do
    before { get :new }
    it 'assigns a match for the form' do
      expect(response).to be_success
      expect(assigns(:match)).to_not be_nil
    end
  end

  describe "#create" do
    it "should create a new match" do
      expect { get :create, winner_name: p1.display_name, loser_name: p2.display_name }.to change(Match, :count).by(1)
      expect(response).to redirect_to admin_matches_path
    end
  end

  describe "#destroy" do
    it "should delete a match" do
      match = Match.create winner: p1, loser: p2
      expect { get :destroy, id: match.id }.to change(Match, :count).by(-1)
      expect(response).to redirect_to admin_matches_path
    end
  end

  describe "#edit" do
    it "should delete a match" do
      match = Match.create winner: p1, loser: p2
      get :edit, id: match.id
      expect(assigns[:match]).to eq match
    end
  end

  describe "#update" do
    it "should update a match" do
      match = Match.create winner: p1, loser: p2
      get :update, id: match.id, winner_name: p2.display_name, loser_name: p1.display_name
      expect(match.reload.winner).to eq p2
      expect(response).to redirect_to admin_matches_path
    end
  end
end
