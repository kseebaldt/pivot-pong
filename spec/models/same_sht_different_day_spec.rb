require 'spec_helper'

describe SameShtDifferentDay do
  let(:me) { Player.create(name: "me") }

  it "should populate achievement specific attributes to achievement on create" do
    achievement = nil
    expect { achievement = SameShtDifferentDay.create(player: me) }.to change(me.achievements, :count).by(1)
    achievement.title.should == "Same Sh*t, Different Day"
    achievement.description.should == "Stay the same rank 7 matches in a row"
    achievement.badge.should == "icon-lock"
  end

  describe "#eligible" do
    it "should be eligible if you stay the same rank 7 matches in a row" do
      logs = []
      7.times{ logs << Hashie::Mash.new(rank: 2) }
      me.stub_chain(:logs, :descending, :limit).and_return(logs)
      SameShtDifferentDay.eligible?(me).should be true
    end
  end
end
