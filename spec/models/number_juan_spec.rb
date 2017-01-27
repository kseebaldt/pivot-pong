require 'spec_helper'

describe NumberJuan do
  let(:me) { Player.create(name: "me") }

  it "should populate achievement specific attributes to achievement on create" do
    achievement = nil
    expect { achievement = NumberJuan.create(player: me) }.to change(me.achievements, :count).by(1)
    expect(achievement.title).to eq "Number Juan"
    expect(achievement.description).to eq "Dos no es un ganador y tres nadie recuerda"
    expect(achievement.badge).to eq "icon-trophy"
  end

  describe "#eligible" do
    let(:you) { Player.create(name: "you") }
    it "should be eligible if you move to 1st place" do
      expect(me.rank).to eq 1
      expect(you.rank).to eq 2
      expect(NumberJuan.eligible?(me)).to eq true
      expect(NumberJuan.eligible?(you)).to eq false
    end
  end
end
