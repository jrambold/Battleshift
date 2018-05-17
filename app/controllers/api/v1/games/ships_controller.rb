module Api
  module V1
    module Games
      class ShipsController < ApiController
        def create
          game = Game.find(params[:game_id])
          # {"ship_size"=>3, "start_space"=>"A1", "end_space"=>"A3"}
          ship_placement = ShipPlacer.new(board: game.player_1_board,
                         ship: Ship.new(params[:ship_size]),
                         start_space: params[:start_space],
                         end_space: params[:end_space]
                        ).run
          player_1 = Player.new(game.player_1_board)
          game.messages = ship_placement + " " + player_1.ships_remaining
          require 'pry'; binding.pry
          render json: game
        end
      end
    end
  end
end
