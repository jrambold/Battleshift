class TurnProcessor
  attr_reader :status

  def initialize(game, target)
    @game   = game
    @target = target
    @messages = []
    @status = 200
  end

  def run!
    begin
      if game.current_turn == "player_1"
        attack_player_2
      else
        attack_player_1
      end
      game.save!
    rescue InvalidAttack => e
      @messages << e.message
      @status = 400
    end
  end

  def message
    @messages.join(" ")
  end

  private

  attr_reader :game, :target

  def attack_player_2
    result = Shooter.fire!(board: player_2.board, target: target)
    @messages << "Your shot resulted in a #{result[0]}."
    @messages << result[1]
    game.player_1_turns += 1
    game.current_turn = "player_2"
  end

  def attack_player_1
    result = Shooter.fire!(board: player_1.board, target: target)
    @messages << "Your shot resulted in a #{result[0]}."
    @messages << result[1]
    game.player_2_turns += 1
    game.current_turn = "player_1"
  end

  def player_1
    Player.new(game.player_1_board)
  end

  def player_2
    Player.new(game.player_2_board)
  end

end
