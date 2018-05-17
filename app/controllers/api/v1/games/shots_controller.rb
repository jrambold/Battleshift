module Api
  module V1
    module Games
      class ShotsController < ApiController
        def create
          game = Game.find(params[:game_id])
          if game.winner
            render json: game, message: "Invalid move. Game over.", status: 400
          elsif game.player_1.api_key == request.headers["HTTP_X_API_KEY"]  && game.current_turn == "player_1"

            turn_processor = TurnProcessor.new(game, params[:shot][:target])

            turn_processor.run!
            render json: game, message: turn_processor.message, status: turn_processor.status

          elsif game.player_2.api_key == request.headers["HTTP_X_API_KEY"] && game.current_turn == "player_2"
            game.player_1.api_key == request.headers["HTTP_X_API_KEY"]

            turn_processor = TurnProcessor.new(game, params[:shot][:target])

            turn_processor.run!
            render json: game, message: turn_processor.message, status: turn_processor.status
          else
            render json: game, message: "Invalid move. It's your opponent's turn", status: 400
          end
        end
      end
    end
  end
end
