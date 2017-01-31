require 'spec_helper'

describe BraggingRights do
  let(:me) { Player.create(name: "me") }

  it "should populate achievement specific attributes to achievement on create" do
    achievement = nil
    expect { achievement = BraggingRights.create(player: me) }.to change(me.achievements, :count).by(1)
    expect(achievement.title).to eq "Bragging Rights"
    expect(achievement.description).to eq "Tweet Your Victory"
    expect(achievement.badge).to eq "fa fa-twitter"
  end

  describe "#eligible" do
    it "should never be eligible" do
      expect(BraggingRights.eligible?(me)).to be false
    end
  end
end
