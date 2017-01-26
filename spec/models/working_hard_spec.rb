require 'spec_helper'

describe WorkingHard do
  let(:me) { Player.create(name: "me") }

  it "should populate achievement specific attributes to achievement on create" do
    achievement = nil
    expect { achievement = WorkingHard.create(player: me) }.to change(me.achievements, :count).by(1)
    achievement.title.should == "Working Hard or Hardly Working?"
    achievement.description.should == "Log more than 5 matches in a single day"
    achievement.badge.should == "icon-headphones"
  end

  describe "#eligible" do
    it "should be eligible if you log more than 5 matches in a single day" do
      me.stub_chain(:matches, :occurred_today, :size).and_return(6)
      WorkingHard.eligible?(me).should be true
    end
  end
end
