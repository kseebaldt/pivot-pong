require 'rails_helper'

describe Totem do
  let(:me) { Player.create(name: 'me') }
  let(:you) { Player.create(name: 'you') }

  it "should be valid" do
    expect(me.totems.create(loser: you)).to be_valid
  end
end
