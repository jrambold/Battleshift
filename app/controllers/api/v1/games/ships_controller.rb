module Api
  module V1
    module Games
      class ShipsController < ApiController
        def create
          game = Game.find(params[:game_id])
          ship_placement = ShipPlacer.new(board: game.player_1_board, ship: Ship.new(params[:ship]).run
          player_1 = Player.new(game.player_1_board)
          game.messages = ship_placement + " " + player_1.ships_remaining
          render json: game, message: "#{game.messages}"
          require 'pry'; binding.pry
        end
      end
    end
  end
end
