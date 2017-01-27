require 'spec_helper'

describe Admin::PlayersController do
  describe "#index" do
    before { get :index }
    it 'shows the players' do
      expect(response).to be_success
      expect(assigns(:players)).to eq Player.all
    end
  end

  describe "#new" do
    before { get :new }
    it 'assigns a player for the form' do
      expect(response).to be_success
      expect(assigns(:player)).to_not be_nil
    end
  end

  describe "#create" do
    it "should create a new player" do
      expect { get :create, player: {name: "foo"} }.to change(Player, :count).by(1)
      expect(response).to redirect_to admin_players_path
    end
  end

  describe "#destroy" do
    it "should delete a player" do
      player = Player.create name: "foo"
      expect { get :destroy, id: player.id }.to change(Player, :count).by(-1)
      expect(response).to redirect_to admin_players_path
    end
  end

  describe "#edit" do
    it "should delete a player" do
      player = Player.create name: "foo"
      get :edit, id: player.id
      expect(assigns[:player]).to eq player
    end
  end

  describe "#update" do
    it "should update a player" do
      player = Player.create name: "foo"
      get :update, id: player.id, player: {name: 'booyah!'}
      expect(player.reload.name).to eq "booyah!"
    end
  end
end
