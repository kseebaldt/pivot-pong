require 'spec_helper'

describe NumberJuan do
  let(:me) { Player.create(name: "me") }

  it "should populate achievement specific attributes to achievement on create" do
    achievement = nil
    expect { achievement = NumberJuan.create(player: me) }.to change(me.achievements, :count).by(1)
    achievement.title.should == "Number Juan"
    achievement.description.should == "Dos no es un ganador y tres nadie recuerda"
    achievement.badge.should == "icon-trophy"
  end

  describe "#eligible" do
    let(:you) { Player.create(name: "you") }
    it "should be eligible if you move to 1st place" do
      me.rank.should == 1
      you.rank.should == 2
      NumberJuan.eligible?(me).should be true
      NumberJuan.eligible?(you).should be false
    end
  end
end
