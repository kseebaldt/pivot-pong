require 'rails_helper'

describe TwilightSaga do
  let(:me) { Player.create(name: "me") }

  it "should populate achievement specific attributes to achievement on create" do
    achievement = nil
    expect { achievement = TwilightSaga.create(player: me) }.to change(me.achievements, :count).by(1)
    expect(achievement.title).to eq "Twilight Saga"
    expect(achievement.description).to eq "Log a match after 6pm PST"
    expect(achievement.badge).to eq "fa fa-clock-o"
  end

  describe "#eligible" do
    let(:you) { Player.create(name: "you") }
    it "Log a match after 6pm PST" do
      create(:match, winner: me, loser: you, occured_at: (Date.today.beginning_of_day + 20.hours))
      expect(TwilightSaga.eligible?(me)).to be true
      expect(TwilightSaga.eligible?(you)).to be true
    end
  end
end
