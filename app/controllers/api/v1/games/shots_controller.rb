module Api
  module V1
    module Games
      class ShotsController < ApiController
        def create
          game = Game.find(params[:game_id])
          user = User.find_by(api_key: request.headers["HTTP_X_API_KEY"])
          turn = TurnProcessor.new(game, user, params[:shot][:target])
          turn.run! if turn.authorized?
          render json: game, message: turn.message, status: turn.status
        end
      end
    end
  end
end
