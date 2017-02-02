require 'rails_helper'

describe Inactive do
  let(:me) { Player.create(name: "me") }

  it "should populate achievement specific attributes to achievement on create" do
    achievement = nil
    expect { achievement = Inactive.create(player: me) }.to change(me.achievements, :count).by(1)
    expect(achievement.title).to eq "Where'd You Go?"
    expect(achievement.description).to eq "Gone inactive after 30 days of not playing"
    expect(achievement.badge).to eq "fa fa-minus-circle"
  end

  describe "#eligible" do
    it "should never be eligible, awarded during mark as inactive" do
      expect(Inactive.eligible?(me)).to be false
    end
  end
end
