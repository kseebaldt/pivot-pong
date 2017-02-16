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
    it "should be eligible if you Log a match before 6pm PST" do
      travel_to Time.current.end_of_day do
        create(:match, winner: me, loser: you, occurred_at: (Time.current.beginning_of_day + 19.hours))
        expect(TwilightSaga.eligible?(me)).to be true
        expect(TwilightSaga.eligible?(you)).to be true
      end
    end

    it "should not be eligible if you Log a match before 6pm PST" do
      travel_to Time.current.end_of_day do
        create(:match, winner: me, loser: you, occurred_at: (Time.current.beginning_of_day + 17.hours))
        expect(TwilightSaga.eligible?(me)).to be false
        expect(TwilightSaga.eligible?(you)).to be false
      end
    end
  end
end
