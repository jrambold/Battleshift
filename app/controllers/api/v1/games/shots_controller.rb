module Api
  module V1
    module Games
      class ShotsController < ApiController
        def create
          game = Game.find(params[:game_id])
          player1 = Player.new(game.player_1_board)
          player2 = Player.new(game.player_2_board)
          if game.player_1_turns == 0 && (player1.ships_count_remaining > 0 || player2.ships_count_remaining > 0)
            render json: game, message: "Ships not placed", status: 400
          else
            user = User.find_by(api_key: request.headers["HTTP_X_API_KEY"])
            turn = TurnProcessor.new(game, user, params[:shot][:target])
            turn.run! if turn.authorized?
            render json: game, message: turn.message, status: turn.status
          end
        end
      end
    end
  end
end
