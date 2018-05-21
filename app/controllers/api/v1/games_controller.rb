module Api
  module V1
    class GamesController < ApiController
      def create
        player = User.find_by(api_key: request.headers.env["HTTP_X_API_KEY"])
        current_game = player.has_current_game(params[:opponent_email])
        if current_game
          render json: current_game, message: "Game #{current_game.id} Already Started", status: 400
        else
          game = Game.start(params[:opponent_email], request.headers.env["HTTP_X_API_KEY"])
          render json: game
        end
      end

      def show
        game = Game.find(params[:id])
        render json: game
      end
    end
  end
end
