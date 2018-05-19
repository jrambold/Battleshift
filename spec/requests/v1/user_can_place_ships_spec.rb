require 'rails_helper'

describe "Api::V1::Ships" do
  context "POST /api/v1/games/:id/ships" do
    let(:player_1_board)   { Board.new(4) }
    let(:player_2_board)   { Board.new(4) }

    it 'can place a ship for player 1' do
      game = create(:game, player_1_board: player_1_board, player_2_board: player_2_board)
      ship_1_payload = {
        ship_size: 3,
        start_space: "A1",
        end_space: "A3"
      }.to_json

      headers = { "CONTENT_TYPE" => "application/json", "HTTP_X_API_KEY" => "abc" }
      post "/api/v1/games/#{game.id}/ships", params: ship_1_payload, headers: headers
    end

    it 'can place a ship for player 2' do
      game = create(:game, player_1_board: player_1_board, player_2_board: player_2_board, current_turn: "player_2")
      ship_1_payload = {
        ship_size: 3,
        start_space: "A1",
        end_space: "A3"
      }.to_json

      headers = { "CONTENT_TYPE" => "application/json", "HTTP_X_API_KEY" => "def" }
      post "/api/v1/games/#{game.id}/ships", params: ship_1_payload, headers: headers
    end
  end
end
