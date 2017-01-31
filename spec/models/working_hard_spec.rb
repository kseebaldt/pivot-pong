require 'spec_helper'

describe WorkingHard do
  let(:me) { Player.create(name: "me") }

  it "should populate achievement specific attributes to achievement on create" do
    achievement = nil
    expect { achievement = WorkingHard.create(player: me) }.to change(me.achievements, :count).by(1)
    expect(achievement.title).to eq "Working Hard or Hardly Working?"
    expect(achievement.description).to eq "Log more than 5 matches in a single day"
    expect(achievement.badge).to eq "fa fa-headphones"
  end

  describe "#eligible" do
    it "should be eligible if you log more than 5 matches in a single day" do
      allow(me).to receive_message_chain(:matches, :occurred_today, :size).and_return(6)
      expect(WorkingHard.eligible?(me)).to be true
    end
  end
end
