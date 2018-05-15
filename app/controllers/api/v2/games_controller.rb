module Api
  module V2
    class GamesController < ApiController
      def show
        game = Game.find(params[:id])
        render json: game
      end
    end
  end
end
