module Api
  module V1
    module Games
      class ShipsController < ApiController
        def create
          game = Game.find(params[:game_id])
          user = User.find_by(api_key: request.headers["HTTP_X_API_KEY"])
          turn = TurnProcessor.new(game, user, target = nil)
          if turn.authorized?
            if game.player_1.api_key == request.headers["HTTP_X_API_KEY"] && game.current_turn == "player_1"
              ship_placement = ShipPlacer.new(board: game.player_1_board,
                             ship: Ship.new(params[:ship_size]),
                             start_space: params[:start_space],
                             end_space: params[:end_space]
                            ).run
              player = Player.new(game.player_1_board)
              game.update(player_1_board: game.player_1_board)
            elsif game.player_2.api_key == request.headers["HTTP_X_API_KEY"] && game.current_turn == "player_2"
              ship_placement = ShipPlacer.new(board: game.player_2_board,
                             ship: Ship.new(params[:ship_size]),
                             start_space: params[:start_space],
                             end_space: params[:end_space]
                            ).run
              player = Player.new(game.player_2_board)
              game.update(player_1_board: game.player_2_board)
            end
            message = ship_placement + " " + player.ships_remaining
            render json: game, message: "#{message}"
          else
            render json: game, message: "Invalid key", status: 400
          end
        end
      end
    end
  end
end
