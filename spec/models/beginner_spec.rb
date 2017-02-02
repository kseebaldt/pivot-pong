require 'rails_helper'

describe Beginner do
  let(:me) { Player.create(name: "me") }

  it "should populate achievement specific attributes to achievement on create" do
    achievement = nil
    expect { achievement = Beginner.create(player: me) }.to change(me.achievements, :count).by(1)
    expect(achievement.title).to eq "Beginner"
    expect(achievement.description).to eq "Welcome to the wonderful game of pong"
    expect(achievement.badge).to eq "fa fa-check"
  end
end
