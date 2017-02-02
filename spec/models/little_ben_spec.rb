require 'rails_helper'

describe LittleBen do
  let(:me) { Player.create(name: "me") }

  it "should populate achievement specific attributes to achievement on create" do
    achievement = nil
    expect { achievement = LittleBen.create(player: me) }.to change(me.achievements, :count).by(1)
    expect(achievement.title).to eq "Little Ben!"
    expect(achievement.description).to eq "Played more than 50 matches"
    expect(achievement.badge).to eq "fa fa-tag"
  end

  describe "#eligible" do
    it "should be eligible if you log more than 50 matches" do
      allow(me).to receive_message_chain(:matches, :descending, :limit, :size).and_return(50)
      expect(LittleBen.eligible?(me)).to be true
    end
  end
end
