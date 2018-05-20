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

      game_info = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(200)
      expect(game_info[:message]).to eq("Successfully placed ship with a size of 3. You have 1 ship(s) to place with a size of 2.")
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

      game_info = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(200)
      expect(game_info[:message]).to eq("Successfully placed ship with a size of 3. You have 1 ship(s) to place with a size of 2.")
    end

    it 'updates message when player_1 has placed a second ship' do
      game = create(:game, player_1_board: player_1_board, player_2_board: player_2_board)
      ship_1_payload = {
        ship_size: 3,
        start_space: "A1",
        end_space: "A3"
      }.to_json
      ship_2_payload = {
        ship_size: 2,
        start_space: "B1",
        end_space: "B2"
      }.to_json

      headers = { "CONTENT_TYPE" => "application/json", "HTTP_X_API_KEY" => "abc" }
      post "/api/v1/games/#{game.id}/ships", params: ship_1_payload, headers: headers

      game_info = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(200)
      expect(game_info[:message]).to eq("Successfully placed ship with a size of 3. You have 1 ship(s) to place with a size of 2.")

      post "/api/v1/games/#{game.id}/ships", params: ship_2_payload, headers: headers

      game_info = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(200)
      expect(game_info[:message]).to eq("Successfully placed ship with a size of 2. You have 0 ship(s) to place.")
    end

    it 'updates message when player_2 has placed a second ship' do
      game = create(:game, player_1_board: player_1_board, player_2_board: player_2_board, current_turn: "player_2")
      ship_1_payload = {
        ship_size: 3,
        start_space: "A1",
        end_space: "A3"
      }.to_json
      ship_2_payload = {
        ship_size: 2,
        start_space: "B1",
        end_space: "B2"
      }.to_json

      headers = { "CONTENT_TYPE" => "application/json", "HTTP_X_API_KEY" => "def" }
      post "/api/v1/games/#{game.id}/ships", params: ship_1_payload, headers: headers

      game_info = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(200)
      expect(game_info[:message]).to eq("Successfully placed ship with a size of 3. You have 1 ship(s) to place with a size of 2.")

      post "/api/v1/games/#{game.id}/ships", params: ship_2_payload, headers: headers

      game_info = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(200)
      expect(game_info[:message]).to eq("Successfully placed ship with a size of 2. You have 0 ship(s) to place.")
    end

    it 'raises error when player_1 attempts to place a ship in an occupied space' do
      game = create(:game, player_1_board: player_1_board, player_2_board: player_2_board)
      ship_1_payload = {
        ship_size: 3,
        start_space: "A1",
        end_space: "A3"
      }.to_json
      ship_2_payload = {
        ship_size: 2,
        start_space: "A1",
        end_space: "A2"
      }.to_json

      headers = { "CONTENT_TYPE" => "application/json", "HTTP_X_API_KEY" => "abc" }

      begin
        post "/api/v1/games/#{game.id}/ships", params: ship_1_payload, headers: headers
        post "/api/v1/games/#{game.id}/ships", params: ship_2_payload, headers: headers
        rescue InvalidShipPlacement => e
          message = e.message
      end

      expect(e).to be_a InvalidShipPlacement
      expect(message).to eq("Attempting to place ship in a space that is already occupied.")
    end

    it 'raises error when player_2 attempts to place a ship in an occupied space' do
      game = create(:game, player_1_board: player_1_board, player_2_board: player_2_board, current_turn: "player_2")
      ship_1_payload = {
        ship_size: 3,
        start_space: "A1",
        end_space: "A3"
      }.to_json
      ship_2_payload = {
        ship_size: 2,
        start_space: "A1",
        end_space: "A2"
      }.to_json

      headers = { "CONTENT_TYPE" => "application/json", "HTTP_X_API_KEY" => "def" }

      begin
        post "/api/v1/games/#{game.id}/ships", params: ship_1_payload, headers: headers
        post "/api/v1/games/#{game.id}/ships", params: ship_2_payload, headers: headers
        rescue InvalidShipPlacement => e
          message = e.message
      end

      expect(e).to be_a InvalidShipPlacement
      expect(message).to eq("Attempting to place ship in a space that is already occupied.")
    end

    it 'raises error when player_1 attempts to place a ship using coordinates that do not coincide with ship length' do
      game = create(:game, player_1_board: player_1_board, player_2_board: player_2_board)
      ship_1_payload = {
        ship_size: 3,
        start_space: "A1",
        end_space: "A4"
      }.to_json

      headers = { "CONTENT_TYPE" => "application/json", "HTTP_X_API_KEY" => "abc" }

      begin
        post "/api/v1/games/#{game.id}/ships", params: ship_1_payload, headers: headers
        rescue InvalidShipPlacement => e
          message = e.message
      end

      expect(e).to be_a InvalidShipPlacement
      expect(message).to eq("Ship size must be equal to the number of spaces you are trying to fill.")
    end

    it 'raises error when player_2 attempts to place a ship using coordinates that do not coincide with ship length' do
      game = create(:game, player_1_board: player_1_board, player_2_board: player_2_board, current_turn: "player_2")
      ship_1_payload = {
        ship_size: 3,
        start_space: "A1",
        end_space: "A4"
      }.to_json

      headers = { "CONTENT_TYPE" => "application/json", "HTTP_X_API_KEY" => "def" }

      begin
        post "/api/v1/games/#{game.id}/ships", params: ship_1_payload, headers: headers
        rescue InvalidShipPlacement => e
          message = e.message
      end

      expect(e).to be_a InvalidShipPlacement
      expect(message).to eq("Ship size must be equal to the number of spaces you are trying to fill.")
    end

    it 'raises error when player_1 attempts to place a ship diagonally' do
      game = create(:game, player_1_board: player_1_board, player_2_board: player_2_board)
      ship_1_payload = {
        ship_size: 3,
        start_space: "A1",
        end_space: "C4"
      }.to_json

      headers = { "CONTENT_TYPE" => "application/json", "HTTP_X_API_KEY" => "abc" }

      begin
        post "/api/v1/games/#{game.id}/ships", params: ship_1_payload, headers: headers
        rescue InvalidShipPlacement => e
          message = e.message
      end

      expect(e).to be_a InvalidShipPlacement
      expect(message).to eq("Ship must be in either the same row or column.")
    end

    it 'raises error when player_2 attempts to place a ship diagonally' do
      game = create(:game, player_1_board: player_1_board, player_2_board: player_2_board, current_turn: "player_2")
      ship_1_payload = {
        ship_size: 3,
        start_space: "A1",
        end_space: "C4"
      }.to_json

      headers = { "CONTENT_TYPE" => "application/json", "HTTP_X_API_KEY" => "def" }

      begin
        post "/api/v1/games/#{game.id}/ships", params: ship_1_payload, headers: headers
        rescue InvalidShipPlacement => e
          message = e.message
      end

      expect(e).to be_a InvalidShipPlacement
      expect(message).to eq("Ship must be in either the same row or column.")
    end

    xit 'raises error when player_1 attempts to place a ship out of turn' do
      game = create(:game, player_1_board: player_1_board, player_2_board: player_2_board, current_turn: "player_2")
      ship_1_payload = {
        ship_size: 3,
        start_space: "A1",
        end_space: "C4"
      }.to_json

      headers = { "CONTENT_TYPE" => "application/json", "HTTP_X_API_KEY" => "abc" }

      post "/api/v1/games/#{game.id}/ships", params: ship_1_payload, headers: headers

      game_info = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(400)
      expect(game_info[:message]).to eq("Invalid key")
    end

    xit 'raises error when player_2 attempts to place a ship out of turn' do
      game = create(:game, player_1_board: player_1_board, player_2_board: player_2_board)
      ship_1_payload = {
        ship_size: 3,
        start_space: "A1",
        end_space: "C4"
      }.to_json

      headers = { "CONTENT_TYPE" => "application/json", "HTTP_X_API_KEY" => "def" }

      post "/api/v1/games/#{game.id}/ships", params: ship_1_payload, headers: headers

      game_info = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(400)
      expect(game_info[:message]).to eq("Invalid key")
    end
  end
end
