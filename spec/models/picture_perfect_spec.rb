require 'spec_helper'

describe PicturePerfect do
  let(:me) { Player.create(name: "me") }

  it "should populate achievement specific attributes to achievement on create" do
    achievement = nil
    expect { achievement = PicturePerfect.create(player: me) }.to change(me.achievements, :count).by(1)
    expect(achievement.title).to eq "Picture Perfect"
    expect(achievement.description).to eq "Upload an avatar in your user profile"
    expect(achievement.badge).to eq "fa fa-camera"
  end

  describe "#eligible" do
    it "should never be eligible" do
      expect(PicturePerfect.eligible?(me)).to be false
    end
  end
end
