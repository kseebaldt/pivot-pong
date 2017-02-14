require 'rails_helper'

describe MatchesController do
  subject { response }

  describe "GET #index" do
    let(:occurred_at) { Time.current }
    let(:me) { Player.create(name: "me") }
    let(:you) { Player.create(name: "you") }
    let!(:newer_match) { create(:match, winner: me, loser: you, occurred_at: occurred_at) }
    let!(:older_match) { create(:match, winner: you, loser: me, occurred_at: occurred_at - 1.day) }

    describe "when achievements are won from a match" do
      before { get :index, d: true }
      it { should be_success }
      it 'shows matches with most recent first' do
        expect(assigns(:matches).sort).to eq Match.order("occurred_at desc").sort
      end

      it 'assigns a match' do
        expect(assigns(:match)).to be
      end

      it 'assigns the most recent match' do
        expect(assigns(:most_recent_match)).to eq Match.order("occurred_at desc").first
      end
    end

    describe "when an achievement qualifying from twitter" do
      it "passes in a match id into d" do
        get :index, d: newer_match.id
        expect(assigns(:most_recent_match)).to eq newer_match
      end
    end
  end

  describe "GET #show" do
    let(:occurred_at) { Time.current }
    let(:me) { Player.create(name: "me") }
    let(:you) { Player.create(name: "you") }
    let!(:match) { create(:match, winner: me, loser: you, occurred_at: occurred_at) }
    it "should assign values for the match and players" do
      get :show, :id => match.to_param
      expect(assigns(:match)).to eq match
      expect(assigns(:winner)).to eq match.winner
      expect(assigns(:loser)).to eq match.loser
    end
  end

  describe "POST #create" do
    let(:match_params) { {winner_name: "taeyang", loser_name: "se7en", match: { occurred_at: '2014-03-22' } } }

    it 'redirects to the list and shows any achievements earned' do
      post :create, match_params
      expect(response).to redirect_to(matches_path(d: true))
    end

    it 'creates a match' do
      expect(MatchRecorder).to receive(:record).with(winner: "taeyang", loser: 'se7en', occurred_at: '2014-03-22')
      post :create, match_params
      expect(flash.alert).to be_nil
    end

    it 'tells the user about errors and redirects without showing achievements earned' do
      expect(MatchRecorder).to receive(:record) { 'Error: Error' }
      post :create, match_params
      expect(flash.alert).to eq('Error: Error')
      expect(response).to redirect_to(matches_path)
    end
  end

  describe "DELETE #destroy" do
    let!(:match) { create(:match) }

    it "destroys the given match" do
      expect { delete :destroy, id: match.to_param }.to change(Match, :count).by(-1)
    end

    context "after deletion" do
      before { delete :destroy, id: match.to_param }
      it { should redirect_to(matches_path) }
    end
  end

  describe "GET #rankings" do
    let(:me) { create(:player, name: "me") }
    let(:you) { create(:player, name: "you") }
    let(:occurred_at) { Time.current }

    it "returns the correctly ranked players" do
      MatchObserver.after_save create(:match, winner: Player.create(name: "one"),
                   loser: Player.create(name: "two"),
                   occurred_at: occurred_at - 10.months)
      MatchObserver.after_save create(:match, winner: Player.create(name: "bro1"),
                   loser: Player.create(name: "bro2"),
                   occurred_at: occurred_at - 2.months)
      MatchObserver.after_save create(:match, winner: you, loser: me, occurred_at: occurred_at - 1.day)
      MatchObserver.after_save create(:match, winner: me.reload, loser: you.reload, occurred_at: occurred_at)

      get :rankings
      expect(response).to be_success
      expect(assigns(:rankings)).to eq [me.reload, you.reload]
    end
  end

  describe "GET #players" do
    it 'can show all the players' do
      expect(Player).not_to receive(:search)
      expect(Player).to receive(:all) { [Player.new(name: 'Danny Burkes'), Player.new(name: 'Edward Hieatt')] }

      get :players

      expect(response).to be_success
      expect(response.body).to eq ['Danny Burkes', 'Edward Hieatt'].join("\n")
    end

    it 'can search for players' do
      expect(Player).to receive(:search).with('foo') { [Player.new(name: 'Danny Burkes'), Player.new(name: 'Edward Hieatt')] }
      expect(Player).not_to receive(:all)

      get :players, q: 'foo'

      expect(response).to be_success
      expect(response.body).to eq ['Danny Burkes', 'Edward Hieatt'].join("\n")
    end
  end
end
