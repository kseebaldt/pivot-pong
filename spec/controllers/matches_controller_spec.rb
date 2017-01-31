require 'spec_helper'

describe MatchesController do
  subject { response }

  describe "GET #index" do
    let(:occured_at) { Time.current }
    let(:me) { Player.create(name: "me") }
    let(:you) { Player.create(name: "you") }
    let!(:newer_match) { Match.create(winner: me, loser: you, occured_at: occured_at) }
    let!(:older_match) { Match.create(winner: you, loser: me, occured_at: occured_at - 1.day) }

    describe "when achievements are won from a match" do
      before { get :index, d: true }
      it { should be_success }
      it 'shows matches with most recent first' do
        expect(assigns(:matches).sort).to eq Match.order("occured_at desc").sort
      end

      it 'assigns a match' do
        expect(assigns(:match)).to be
      end

      it 'assigns the most recent match' do
        expect(assigns(:most_recent_match)).to eq Match.order("occured_at desc").first
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
    let(:occured_at) { Time.current }
    let(:me) { Player.create(name: "me") }
    let(:you) { Player.create(name: "you") }
    let!(:match) { Match.create(winner: me, loser: you, occured_at: occured_at) }
    it "should assign values for the match and players" do
      get :show, :id => match.to_param
      expect(assigns(:match)).to eq match
      expect(assigns(:winner)).to eq match.winner
      expect(assigns(:loser)).to eq match.loser
    end
  end

  describe "POST #create" do
    let(:match_params) { {winner_name: "taeyang", loser_name: "se7en" } }

    describe "redirection" do
      before { post :create, match_params }
      it { should redirect_to(matches_path(d: true)) }
    end

    it "creates a match" do
      expect { post :create, match_params }.to change(Match, :count).by(1)
    end

    it "finds players that already exist, case insensitively" do
      foo = Player.create(name: "foo")
      bar = Player.create(name: "bar")
      post :create, {winner_name: "Foo", loser_name: "bar"}
      match = Match.last
      expect(match.winner).to eq foo
      expect(match.loser).to eq bar
    end

    it "doesn't create a match if winner or loser is blank" do
      expect { post :create, {winner_name: "", loser_name: "bar"} }.to_not change(Match, :count)
      expect { post :create, {winner_name: "foo", loser_name: ""} }.to_not change(Match, :count)
      expect { post :create, {winner_name: "", loser_name: ""} }.to_not change(Match, :count)

    end

    context "when the winner name includes extra whitespace" do
      before { post :create, params }

      let(:params) { {winner_name: "Winner McWinnerson   ", loser_name: "Loser O'Loserly   " } }
      let(:winner) { Player.find_by_name "winner mcwinnerson" }
      let(:loser) { Player.find_by_name "loser o'loserly" }

      it "strips whitespace from player names" do
        expect(winner).to be
        expect(loser).to be
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:match) { Match.create(winner: Player.create(name: "gd"), loser: Player.create(name: "top")) }

    it "destroys the given match" do
      expect { delete :destroy, id: match.to_param }.to change(Match, :count).by(-1)
    end

    context "after deletion" do
      before { delete :destroy, id: match.to_param }
      it { should redirect_to(matches_path) }
    end
  end

  describe "GET #rankings" do
    let(:me) { Player.create(name: "me") }
    let(:you) { Player.create(name: "you") }
    let(:occured_at) { Time.current }

    it "returns the correctly ranked players" do
      MatchObserver.new.after_save Match.create(winner: Player.create(name: "one"),
                   loser: Player.create(name: "two"),
                   occured_at: occured_at - 10.months)
      MatchObserver.new.after_save Match.create(winner: Player.create(name: "bro1"),
                   loser: Player.create(name: "bro2"),
                   occured_at: occured_at - 2.months)
      MatchObserver.new.after_save Match.create(winner: you, loser: me, occured_at: occured_at - 1.day)
      MatchObserver.new.after_save Match.create(winner: me.reload, loser: you.reload, occured_at: occured_at)

      get :rankings
      expect(response).to be_success
      expect(assigns(:rankings)).to eq [me.reload, you.reload]
    end
  end

  describe "GET #players" do
    before do
      @match1 = Match.create(winner: Player.create(name: "Danny Burkes"), loser: Player.create(name: "Edward Hieatt"))
      @match2 = Match.create(winner: Player.create(name: "Robert deForest"), loser: Player.create(name: "Parker Thompson"))
    end

    it "renders a sorted list of player names" do
      get :players
      expect(response).to be_success
      expect(response.body).to eq ["Danny Burkes", "Edward Hieatt", "Parker Thompson", "Robert deForest"].join("\n")
    end

    it "takes a query parameter" do
      get :players, q: "d"
      expect(response).to be_success
      expect(response.body).to eq ["Danny Burkes", "Robert deForest"].join("\n")
    end

    it "applies the query parameter case-insensitively to each space separated name-part" do
      get :players, q: "D"
      expect(response).to be_success
      expect(response.body).to eq ["Danny Burkes", "Robert deForest"].join("\n")
    end
  end
end
