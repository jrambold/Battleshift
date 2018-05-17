require 'rails_helper'

describe 'Player' do
  describe 'initialize' do
    subject { Player.new({}) }
    it 'initializes with board' do
      expect(subject).to be_a Player
    end
  end

  describe 'instance methods' do
    describe '#ships_remaining' do
      it 'returns a message regarding player ships remaining when called after placing ship size 2' do
        board = Board.new(4)
        ship = Ship.new(2)

        ShipPlacer.new(board: board,
                       ship: ship,
                       start_space: "A1",
                       end_space: "B1"
                      ).run

        player = Player.new(board)

        expect(player.ships_remaining).to eq("You have 1 ship(s) to place with a size of 3.")
      end

      it 'and returns a different message regarding player ships remaining when called after placing ship size 3' do
        board = Board.new(4)
        ship = Ship.new(3)

        ShipPlacer.new(board: board,
                       ship: ship,
                       start_space: "A1",
                       end_space: "A3"
                      ).run

        player = Player.new(board)

        expect(player.ships_remaining).to eq("You have 1 ship(s) to place with a size of 2.")
      end

      it 'and returns a message that no ships are remaining when called after placing both ships' do
        board = Board.new(4)
        ship_1 = Ship.new(2)
        ship_2 = Ship.new(3)

        ShipPlacer.new(board: board,
                       ship: ship_1,
                       start_space: "A1",
                       end_space: "B1"
                      ).run

        ShipPlacer.new(board: board,
                       ship: ship_2,
                       start_space: "A2",
                       end_space: "A4"
                      ).run

        player = Player.new(board)

        expect(player.ships_remaining).to eq("You have 0 ship(s) to place.")
      end
    end
  end
end
