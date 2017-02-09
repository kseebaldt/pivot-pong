require 'rails_helper'

describe "matches/index.html.haml" do
  let!(:occurred_at) { 2.days.ago }
  let!(:match) { create(:match, winner: Player.create(name: "cl"), loser: Player.create(name: "Minzy"), occurred_at: occurred_at) }
  before do
    assign :matches, Match.paginate(:page => 1).order("occurred_at DESC")
    assign :match, Match.new
    render
  end
  subject { rendered }
  it { should be }
  it { should include("cl") }
  it { should include("Minzy") }
  it { should include(occurred_at.strftime("%Y-%m-%d")) }
  it { should include("https://twitter.com/intent/tweet") }
end
