require 'spec_helper'

describe TwilightSaga do
  let(:me) { Player.create(name: "me") }

  it "should populate achievement specific attributes to achievement on create" do
    achievement = nil
    expect { achievement = TwilightSaga.create(player: me) }.to change(me.achievements, :count).by(1)
    achievement.title.should == "Twilight Saga"
    achievement.description.should == "Log a match after 6pm PST"
    achievement.badge.should == "icon-time"
  end

  describe "#eligible" do
    let(:you) { Player.create(name: "you") }
    it "Log a match after 6pm PST" do
      Match.create(winner: me, loser: you, occured_at: (Date.today.beginning_of_day + 20.hours))
      TwilightSaga.eligible?(me).should be true
      TwilightSaga.eligible?(you).should be true
    end
  end
end
