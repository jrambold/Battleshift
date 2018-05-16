class Player
  attr_reader :board

  def initialize(board)
    @board = board
  end

  def ships_remaining
    ships_remaining = 2
    board.each do |space|
      if space.contents
        if space.contents.length == 3
          ships_remaining = 1
        elsif space.conents.length == 2
          ships_remaining = 0
          break
        end
      end
    end
    case ships_remaining
      when 2
        "You have 2 ship(s) to place with a size of 3 and 2."
      when 1
        "You have 1 ship(s) to place with a size of 2."
      else
        "You have 0 ship(s) to place."
    end
  end
end
