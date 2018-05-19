require 'rails_helper'

RSpec.describe Board, type: :model do
  describe 'initialize' do
    it 'initializes with length and board' do
      board = Board.new(4)
      expect(board.length).to eq(4)
      expect(board.board).to be_a Array
    end
  end

  describe 'instance methods' do
    describe '#get_row_letters' do
      it 'has row letters' do
        board = Board.new(4)
        letters = board.get_row_letters
        expect(letters).to eq(["A", "B", "C", "D"])
      end
    end
    describe '#get_column_numbers' do
      it 'has column numbers' do
        board = Board.new(4)
        numbers = board.get_column_numbers
        expect(numbers).to eq(["1", "2", "3", "4"])
      end
    end
    describe '#space_names' do
      it 'makes an array of space names' do
        board = Board.new(4)
        names = board.space_names
        expect(names).to eq(["A1", "A2", "A3", "A4", "B1", "B2", "B3", "B4", "C1", "C2", "C3", "C4", "D1", "D2", "D3", "D4"])
      end
    end
    describe '#create_spaces' do
      it 'makes a hash of space objects' do
        board = Board.new(4)
        hash = board.create_spaces
        hash.values.each do |space|
          expect(space).to be_a Space
        end
      end
    end

  end
end
