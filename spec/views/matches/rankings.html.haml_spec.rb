require 'rails_helper'

describe "matches/rankings.html.haml" do
  let(:me) { Player.create(name: "me") }
  let(:you) { Player.create(name: "you") }
  before do
    assign :rankings, [me, you]
    render
  end
  subject { rendered }
  it { should be }
  it { should include(me.display_name) }
  it { should include(you.display_name) }
end
