require 'rails_helper'

describe MatchRecorder do
  before do
    allow(MatchObserver).to receive(:after_save)
  end

  describe '#record' do
    it 'makes a match and players' do
      expect do
        expect do
          errors = MatchRecorder.record(winner: 'foo', loser: 'bar', occurred_at: Time.new(2015, 1, 5))
          expect(errors).to be_nil
        end.to change(Match, :count).by(1)
      end.to change(Player, :count).by(2)

      match = Match.last
      expect(match.occurred_at).to eq(Time.new(2015, 1, 5))
      expect(match.winner.name).to eq 'foo'
      expect(match.loser.name).to eq 'bar'
    end

    it 'case insenstive finds existing players' do
      win = Player.create!(name: 'Foo Bar')
      lose = Player.create!(name: 'Bar Baz')

      expect do
        MatchRecorder.record(winner: 'foo bAr', loser: 'bAr baZ', occurred_at: Date.new(2015, 1, 5))
      end.not_to change(Player, :count)

      expect(Match.last.winner).to eq(win)
      expect(Match.last.loser).to eq(lose)
    end

    it 'reports an error when no winner or loser is specified' do
      no_winner = MatchRecorder.record(winner: '', loser: 'foo', occurred_at: Date.new(2015, 1, 5))
      expect(no_winner).to eq('Must specify a winner and a loser to post a match.')
      no_loser = MatchRecorder.record(winner: 'foo', loser: '', occurred_at: Date.new(2015, 1, 5))
      expect(no_loser).to eq('Must specify a winner and a loser to post a match.')

      expect(MatchObserver).not_to have_received(:after_save)
    end

    it 'sets a default occurred_at to now' do
      travel_to Time.new(2014, 3, 2, 9, 30, 0) do
        MatchRecorder.record(winner: 'foo', loser: 'bar', occurred_at: '')
      end

      expect(Match.last.occurred_at).to eq(Time.new(2014, 3, 2, 9, 30, 0))
    end

    it 'reports all the errors when a match failed to save' do
      expect do
        errors = MatchRecorder.record(winner: 'foo', loser: 'bar', occurred_at: 'InvalidTime')
        expect(errors).not_to be_nil
      end.not_to change(Match, :count)

      expect(MatchObserver).not_to have_received(:after_save)
    end

    it 'removes extra whitespace for new players' do
      MatchRecorder.record(winner: '  Hi there   ', loser: '  Good Bye  ', occurred_at: Date.new(2015, 1, 5))

      match = Match.last
      expect(match.winner.name).to eq('Hi there')
      expect(match.loser.name).to eq('Good Bye')
    end

    it 'removes extra whitespace when finding players' do
      win = Player.create!(name: 'Foo Bar')
      lose = Player.create!(name: 'Bar Baz')

      expect do
        MatchRecorder.record(winner: ' Foo Bar  ', loser: '   Bar Baz ', occurred_at: Date.new(2015, 1, 5))
      end.not_to change(Player, :count)

      expect(Match.last.winner).to eq(win)
      expect(Match.last.loser).to eq(lose)
    end

    it 'tells the match observer about the new match' do
      MatchRecorder.record(winner: 'Foo Bar', loser: 'Bar Baz', occurred_at: Date.new(2015, 1, 5))
      expect(MatchObserver).to have_received(:after_save).with(instance_of(Match))
    end
  end

  describe '#update' do
    let(:me) { Player.create(name: "me") }
    let(:you) { Player.create(name: "you") }
    let(:him) { Player.create(name: "him") }

    it 'updates a match' do
      match = create(:match, winner: me, loser: you, occurred_at: Time.new(2015, 1, 4))

      expect do
        expect do
          errors = MatchRecorder.update(match: match, winner: 'me', loser: 'him', occurred_at: Time.new(2015, 1, 5))
          expect(errors).to be_nil
        end.not_to change(Match, :count)
      end.to change(Player, :count).by(1)

      match = Match.last
      expect(match.occurred_at).to eq(Time.new(2015, 1, 5))
      expect(match.winner.name).to eq 'me'
      expect(match.loser.name).to eq 'him'
    end

    it 'reports an error when no winner or loser is specified' do
      match = create(:match, winner: me, loser: you, occurred_at: Time.new(2015, 1, 4))

      no_winner = MatchRecorder.update(match: match, winner: '', loser: 'foo', occurred_at: Date.new(2015, 1, 5))
      expect(no_winner).to eq('Must specify a winner and a loser to update a match.')
      no_loser = MatchRecorder.update(match: match, winner: 'foo', loser: '', occurred_at: Date.new(2015, 1, 5))
      expect(no_loser).to eq('Must specify a winner and a loser to update a match.')

      expect(MatchObserver).not_to have_received(:after_save)
    end

    it 'reports all the errors when a match failed to update' do
      match = create(:match, winner: me, loser: you, occurred_at: Time.new(2015, 1, 4))

      expect do
        errors = MatchRecorder.update(match: match, winner: 'me', loser: 'him', occurred_at: 'InvalidTime')
        expect(errors).not_to be_nil
      end.not_to change(Match, :count)

      expect(MatchObserver).not_to have_received(:after_save)
    end

    it 'tells the match observer about the new match' do
      match = create(:match, winner: me, loser: you, occurred_at: Time.new(2015, 1, 4))

      MatchRecorder.update(match: match, winner: 'Foo Bar', loser: 'Bar Baz', occurred_at: Date.new(2015, 1, 5))
      expect(MatchObserver).to have_received(:after_save).with(instance_of(Match))
    end
  end
end