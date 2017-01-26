require 'spec_helper'

describe LongJump do
  let(:me) { Player.create(name: "me") }

  it "should populate achievement specific attributes to achievement on create" do
    achievement = nil
    expect { achievement = LongJump.create(player: me) }.to change(me.achievements, :count).by(1)
    achievement.title.should == "Long Jump"
    achievement.description.should == "Advances more than 3 spots in rank from a single match"
    achievement.badge.should == "icon-circle-arrow-up"
  end

  describe "#eligible" do
    it "should be eligible if your diff of last 2 logs increases your rank by at least 4" do
      log_1 = Hashie::Mash.new(rank: 1)
      log_2 = Hashie::Mash.new(rank: 5)
      me.stub_chain(:logs, :descending, :limit).and_return([log_1, log_2])
      LongJump.eligible?(me).should be true
    end
  end
end
