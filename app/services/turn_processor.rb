class TurnProcessor
  attr_reader :status

  def initialize(game, user, target)
    @game = game
    @user = user
    @target = target
    @messages = []
    @status = 200
  end

  def authorized?
    if user.nil? || [game.player_1, game.player_2].exclude?(user)
      return unauthorized_move
    elsif game.winner
      return game_over  
    elsif game.current_turn == "player_1" && user != game.player_1
      return invalid_turn
    elsif game.current_turn == "player_2" && user != game.player_2
      return invalid_turn
    end
    return true
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

    attr_reader :game, :user, :target

    def attack_player_2
      result = Shooter.fire!(board: player_2.board, target: target)
      @messages << "Your shot resulted in a #{result[0]}."
      @messages << result[1]
      game.player_1_turns += 1
      if result[2]
        game.winner = game.player_1.id
      end
      game.current_turn = "player_2"
    end

    def attack_player_1
      result = Shooter.fire!(board: player_1.board, target: target)
      @messages << "Your shot resulted in a #{result[0]}."
      @messages << result[1]
      if result[2]
        game.winner = game.player_2.id
      end
      game.player_2_turns += 1
      game.current_turn = "player_1"
    end

    def invalid_turn
      @status = 400
      @messages << "Invalid move. It's your opponent's turn"
      false
    end

    def unauthorized_move
      @status = 401
      @messages << "Unauthorized"
      false
    end

    def game_over
      @status = 400
      @messages << "Invalid move. Game over."
      false
    end

    def player_1
      Player.new(game.player_1_board)
    end

    def player_2
      Player.new(game.player_2_board)
    end
end
