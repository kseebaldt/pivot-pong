require 'spec_helper'

describe BigBen do
  let(:me) { Player.create(name: "me") }

  it "should populate achievement specific attributes to achievement on create" do
    achievement = nil
    expect { achievement = BigBen.create(player: me) }.to change(me.achievements, :count).by(1)
    expect(achievement.title).to eq "Big Ben!"
    expect(achievement.description).to eq "Played more than 100 matches"
    expect(achievement.badge).to eq "icon-tags"
  end

  describe "#eligible" do
    it "should be eligible if you log more than 100 matches" do
      allow(me).to receive_message_chain(:matches, :limit, :size).and_return(100)
      expect(BigBen.eligible?(me)).to be true
    end
  end
end
