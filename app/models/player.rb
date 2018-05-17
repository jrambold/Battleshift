class Player
  attr_reader :board

  def initialize(board)
    @board = board
    @ships = [2, 3]
  end

  def ships_remaining
    board.board.each do | block |
      block.each do | row |
        ships.delete(row.values[0].contents.length) if row.values[0].contents
      end
    end
    "You have #{ships.length} ship(s) to place#{check_ships}."
  end

  private
    attr_reader :ships

    def check_ships
      unless ships.empty?
        " with a size of #{ships.first}"
      end
    end
end
