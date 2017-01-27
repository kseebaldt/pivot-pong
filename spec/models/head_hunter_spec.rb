require 'spec_helper'

describe HeadHunter do
  let(:me) { Player.create(name: "me") }

  it "should populate achievement specific attributes to achievement on create" do
    achievement = nil
    expect { achievement = HeadHunter.create(player: me) }.to change(me.achievements, :count).by(1)
    expect(achievement.title).to eq "Head Hunter"
    expect(achievement.description).to eq "Accumulate 10 or more totems for your totem pole"
    expect(achievement.badge).to eq "icon-user"
  end

  describe "#eligible" do
    let(:you) { Player.create(name: "you") }
    it "should be eligible if your totem count is 10 or more" do
      allow(me).to receive_message_chain(:totems, :count).and_return(10)
      expect(HeadHunter.eligible?(me)).to be true
    end
  end
end
