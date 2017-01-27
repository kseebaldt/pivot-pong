require 'spec_helper'

describe Achievement do
  let(:me) { Player.create(name: "me") }

  it "should require a player and a type" do
    expect(Achievement).to receive(:title).and_return("Title")
    expect(Achievement).to receive(:description).and_return("Description")
    expect(Achievement).to receive(:badge).and_return("Badge")
    achievement = me.achievements.new
    achievement.type = "Foo"
    expect { achievement.save }.to change(Achievement, :count).by(1)
  end
end
