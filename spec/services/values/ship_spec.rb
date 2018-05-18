require 'rails_helper'

describe Ship do
  subject { Ship.new(3) }
  it 'initializes with length parameter' do
    expect(subject).to be_a Ship
  end

  describe 'class methods' do
    describe '#attack!' do
      it 'increments damage on ship by one each time it is called' do
        expect(subject.damage).to eq(0)

        subject.attack!
        expect(subject.damage).to eq(1)

        subject.attack!
        expect(subject.damage).to eq(2)
      end
    end

    describe '#is_sunk?' do
      it 'returns boolean based on whether damage is equal to ships length' do
        subject.attack!
        subject.attack!

        expect(subject.is_sunk?).to be_falsey

        subject.attack!

        expect(subject.is_sunk?).to be_truthy
      end
    end
  end
end
