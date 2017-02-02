require 'rails_helper'

describe Admin::MatchesController do
  let!(:p1) { Player.create name: 'me' }
  let!(:p2) { Player.create name: 'you' }

  describe "#new" do
    before { get :new }
    it 'assigns a match for the form' do
      expect(response).to be_success
      expect(assigns(:match)).to_not be_nil
    end
  end

  describe "#create" do
    it "should create a new match" do
      expect { put :create, winner_name: p1.display_name, loser_name: p2.display_name, match: { occured_at: '2014-02-22' } }.to change(Match, :count).by(1)
      expect(response).to redirect_to admin_matches_path
    end
  end

  describe "#destroy" do
    it "should delete a match" do
      match = create :match, winner: p1, loser: p2
      expect { delete :destroy, id: match.id }.to change(Match, :count).by(-1)
      expect(response).to redirect_to admin_matches_path
    end
  end

  describe "#edit" do
    it "should delete a match" do
      match = create :match, winner: p1, loser: p2
      get :edit, id: match.id
      expect(assigns[:match]).to eq match
    end
  end

  describe "#update" do
    it "should update a match" do
      match = create :match, winner: p1, loser: p2
      post :update, id: match.id, winner_name: p2.display_name, loser_name: p1.display_name
      expect(match.reload.winner).to eq p2
      expect(response).to redirect_to admin_matches_path
    end
  end
end
