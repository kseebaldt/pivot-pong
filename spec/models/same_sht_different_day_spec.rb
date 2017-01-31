require 'spec_helper'

describe SameShtDifferentDay do
  let(:me) { Player.create(name: "me") }

  it "should populate achievement specific attributes to achievement on create" do
    achievement = nil
    expect { achievement = SameShtDifferentDay.create(player: me) }.to change(me.achievements, :count).by(1)
    expect(achievement.title).to eq "Same Sh*t, Different Day"
    expect(achievement.description).to eq "Stay the same rank 7 matches in a row"
    expect(achievement.badge).to eq "fa fa-lock"
  end

  describe "#eligible" do
    it "should be eligible if you stay the same rank 7 matches in a row" do
      logs = []
      7.times{ logs << Hashie::Mash.new(rank: 2) }
      allow(me).to receive_message_chain(:logs, :descending, :limit).and_return(logs)
      expect(SameShtDifferentDay.eligible?(me)).to be true
    end
  end
end
