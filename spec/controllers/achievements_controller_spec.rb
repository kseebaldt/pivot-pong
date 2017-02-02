require 'rails_helper'

describe AchievementsController do
  it "can show a list of achievements" do
    get :index
    expect(response).to be_success
    expect(assigns(:achievements)).to eq Achievement.subclasses
  end

  describe "#show" do
    it "loads the achievement" do
      achievement = Beginner.create(player: Player.create(name: 'me'))
      get :show, id: 'beginner'
      expect(response).to be_success
      expect(assigns(:achievement)).to eq Beginner
      expect(assigns(:achievements)).to eq [achievement]
    end
  end
end
