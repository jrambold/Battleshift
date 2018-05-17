module Api
  module V1
    class GamesController < ApiController
      def create
        game = Game.start(params[:opponent_email], request.headers.env["HTTP_X_API_KEY"])
        render json: game
      end

      def show
        game = Game.find(params[:id])
        render json: game
      end
    end
  end
end
