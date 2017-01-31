require 'spec_helper'

describe "matches/index.html.haml" do
  let!(:occured_at) { 2.days.ago }
  let!(:match) { Match.create(winner: Player.create(name: "cl"), loser: Player.create(name: "Minzy"), occured_at: occured_at) }
  before do
    assign :matches, Match.paginate(:page => 1).order("occured_at DESC")
    assign :match, Match.new
    render
  end
  subject { rendered }
  it { should be }
  it { should include("cl") }
  it { should include("Minzy") }
  it { should include(occured_at.strftime("%Y-%m-%d")) }
  it { should include("https://twitter.com/intent/tweet") }
end
