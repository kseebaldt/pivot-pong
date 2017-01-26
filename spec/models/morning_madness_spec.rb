require 'spec_helper'

describe MorningMadness do
  let(:me) { Player.create(name: "me") }

  it "should populate achievement specific attributes to achievement on create" do
    achievement = nil
    expect { achievement = MorningMadness.create(player: me) }.to change(me.achievements, :count).by(1)
    achievement.title.should == "Morning Madness"
    achievement.description.should == "Log a match before 9am PST"
    achievement.badge.should == "icon-adjust"
  end

  describe "#eligible" do
    let(:you) { Player.create(name: "you") }
    it "Log a match before 9am PST" do
      Match.create(winner: me, loser: you, occured_at: (Date.today.beginning_of_day + 8.hours))
      MorningMadness.eligible?(me).should be true
      MorningMadness.eligible?(you).should be true
    end
  end
end
