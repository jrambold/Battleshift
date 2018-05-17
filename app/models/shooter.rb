class Shooter

  def initialize(board:, target:)
    @board     = board
    @target    = target
    @message   = ""
    @game_over = false
  end

  def fire!
    if valid_shot?
      result = space.attack!
      if space.contents && space.contents.is_sunk?
        if game_over?
          @message = "Battleship sunk. Game over."
          @game_over = true
        else
          @message = "Battleship sunk."
        end
      end
      [result, @message, @game_over]
    else
      raise InvalidAttack.new("Invalid coordinates.")
    end
  end

  def game_over?
    board.board.each do | block |
      block.each do | row |
        return false if row.values[0].contents && row.values[0].status == "Not Attacked"
      end
    end
    true
  end


  def self.fire!(board:, target:)
    new(board: board, target: target).fire!
  end

  private
    attr_reader :board, :target

    def space
      @space ||= board.locate_space(target)
    end

    def valid_shot?
      board.space_names.include?(target)
    end
end

class InvalidAttack < StandardError
  def initialize(msg = "Invalid attack.")
    super(msg)
  end
end
