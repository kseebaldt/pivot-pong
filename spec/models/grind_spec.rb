require 'spec_helper'

describe Grind do
  let(:me) { Player.create(name: "me") }

  it "should populate achievement specific attributes to achievement on create" do
    achievement = nil
    expect { achievement = Grind.create(player: me) }.to change(me.achievements, :count).by(1)
    achievement.title.should == "The Grind"
    achievement.description.should == "Play 5 consecutive matches without changing rank"
    achievement.badge.should == "icon-cogs"
  end

  describe "#eligible" do
    it "should be eligible if play 3 matches and maintain the same rank throughout" do
      log_1 = Hashie::Mash.new(rank: 2)
      log_2 = Hashie::Mash.new(rank: 2)
      log_3 = Hashie::Mash.new(rank: 2)
      log_4 = Hashie::Mash.new(rank: 2)
      log_5 = Hashie::Mash.new(rank: 2)
      me.stub_chain(:logs, :descending, :limit).and_return([log_1, log_2, log_3, log_4, log_5])
      Grind.eligible?(me).should be true
    end
  end
end
