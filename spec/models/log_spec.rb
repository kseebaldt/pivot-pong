require 'spec_helper'

describe Log do
  let(:me){ Player.create(name: 'me') }
  let(:you){ Player.create(name: 'you') }

  it "should be created after a match" do
    match = Match.create(winner: me, loser: you)
    me_log = me.reload.logs.first
    you_log = you.reload.logs.first
    expect(me_log.match).to eq match
    expect(me_log.rank).to eq me.rank
    expect(you_log.match).to eq match
    expect(you_log.rank).to eq you.rank
  end
end
