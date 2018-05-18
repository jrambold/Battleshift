require 'rails_helper'

describe Space do
  subject { Space.new("A1") }
  it 'initializes with coordinates' do
    expect(subject).to be_a Space
    expect(subject.coordinates).to eq("A1")
  end

  describe 'class methods' do
    describe '#occupy!' do
      it 'adds a ship to space contents' do
        ship = Ship.new(3)
        expect(subject.contents).to be_nil


        subject.occupy!(ship)
        expect(subject.contents).to eq(ship)
      end
    end

    describe '#occupied?' do
      it 'returns a boolean depending on whether space had contents (ie a ship)' do
        ship = Ship.new(3)
        expect(subject.occupied?).to be_falsey

        subject.occupy!(ship)
        expect(subject.occupied?).to be_truthy
      end
    end

    describe '#attack!' do
      it 'returns miss if there are no contents (ie no ship)' do
        expect(subject.attack!).to eq("Miss")
      end
      it 'returns hit if there are contents (ie a ship)' do
        ship = Ship.new(3)
        subject.occupy!(ship)

        expect(subject.attack!).to eq("Hit")
      end
    end

    describe '#not_attacked?' do
      it 'returns a boolean depending on whether the space has been attacked by opponent' do
        ship = Ship.new(3)
        expect(subject.not_attacked?).to be_truthy

        subject.occupy!(ship)
        subject.attack!

        expect(subject.not_attacked?).to be_falsey
      end
    end
  end
end
