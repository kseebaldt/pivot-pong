require 'spec_helper'

describe HeadHunter do
  let(:me) { Player.create(name: "me") }

  it "should populate achievement specific attributes to achievement on create" do
    achievement = nil
    expect { achievement = HeadHunter.create(player: me) }.to change(me.achievements, :count).by(1)
    achievement.title.should == "Head Hunter"
    achievement.description.should == "Accumulate 10 or more totems for your totem pole"
    achievement.badge.should == "icon-user"
  end

  describe "#eligible" do
    let(:you) { Player.create(name: "you") }
    it "should be eligible if your totem count is 10 or more" do
      me.stub_chain(:totems, :count).and_return(10)
      HeadHunter.eligible?(me).should be true
    end
  end
end
