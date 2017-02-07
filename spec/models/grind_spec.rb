require 'rails_helper'

describe Grind do
  let(:me) { Player.create(name: "me") }

  it "should populate achievement specific attributes to achievement on create" do
    achievement = nil
    expect { achievement = Grind.create(player: me) }.to change(me.achievements, :count).by(1)
    expect(achievement.title).to eq "The Grind"
    expect(achievement.description).to eq "Play 5 consecutive matches without changing rank"
    expect(achievement.badge).to eq "fa fa-cogs"
  end

  describe "#eligible" do
    it "should be eligible if you play 5 matches and maintain the same rank throughout" do
      log_1 = Hashie::Mash.new(rank: 2)
      log_2 = Hashie::Mash.new(rank: 2)
      log_3 = Hashie::Mash.new(rank: 2)
      log_4 = Hashie::Mash.new(rank: 2)
      log_5 = Hashie::Mash.new(rank: 2)
      allow(me).to receive_message_chain(:logs, :descending, :limit).and_return([log_1, log_2, log_3, log_4, log_5])
      expect(Grind.eligible?(me)).to eq true
    end

    it "should not be eligible if you played less than 5 matches" do
      log_1 = Hashie::Mash.new(rank: 2)
      log_2 = Hashie::Mash.new(rank: 2)
      log_3 = Hashie::Mash.new(rank: 2)
      log_4 = Hashie::Mash.new(rank: 2)
      allow(me).to receive_message_chain(:logs, :descending, :limit).and_return([log_1, log_2, log_3, log_4])
      expect(Grind.eligible?(me)).to eq false
    end

    it "should not be eligible if you changed rank within the last 5 matches" do
      log_1 = Hashie::Mash.new(rank: 2)
      log_2 = Hashie::Mash.new(rank: 2)
      log_3 = Hashie::Mash.new(rank: 2)
      log_4 = Hashie::Mash.new(rank: 2)
      log_5 = Hashie::Mash.new(rank: 1)
      allow(me).to receive_message_chain(:logs, :descending, :limit).and_return([log_1, log_2, log_3, log_4, log_5])
      expect(Grind.eligible?(me)).to eq false
    end
  end
end
