require 'rails_helper'

describe Achievement do
  let(:me) { Player.create(name: "me") }

  it "should require a player and a type" do
    achievement = me.achievements.new
    achievement.type = "Foo"
    expect { achievement.save }.to change(Achievement, :count).by(1)
  end
end
