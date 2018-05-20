require 'rails_helper'

describe "Api::V1::Shots" do
  context "POST /api/v1/games/:id/shots" do
    let(:player_1_board)   { Board.new(4) }
    let(:player_2_board)   { Board.new(4) }
    let(:player_1_header) { { "CONTENT_TYPE" => "application/json", "HTTP_X_API_KEY" => "abc" } }
    let(:player_2_header) { { "CONTENT_TYPE" => "application/json", "HTTP_X_API_KEY" => "def" } }
    let(:sm_ship) { Ship.new(2) }

    it "updates the message and board with a miss for player_1" do
      game = create(:game, player_1_board: player_1_board, player_2_board: player_2_board)
      json_payload = {target: "A1"}.to_json
      post "/api/v1/games/#{game.id}/shots", params: json_payload, headers: player_1_header

      expect(response).to be_success

      game_info = JSON.parse(response.body, symbolize_names: true)

      expected_messages = "Your shot resulted in a Miss. "
      player_1_targeted_space = game_info[:player_2_board][:rows].first[:data].first[:status]

      expect(response.status).to eq(200)
      expect(game_info[:message]).to eq expected_messages
      expect(player_1_targeted_space).to eq("Miss")
    end

    it "updates the message and board with a miss for both player_2" do
      game = create(:game, player_1_board: player_1_board, player_2_board: player_2_board, current_turn: "player_2")
      json_payload = {target: "A1"}.to_json
      post "/api/v1/games/#{game.id}/shots", params: json_payload, headers: player_2_header

      expect(response).to be_success

      game_info = JSON.parse(response.body, symbolize_names: true)

      expected_messages = "Your shot resulted in a Miss. "
      player_2_targeted_space = game_info[:player_1_board][:rows].first[:data].first[:status]

      expect(response.status).to eq(200)
      expect(game_info[:message]).to eq expected_messages
      expect(player_2_targeted_space).to eq("Miss")
    end

    it "updates the message but not the board with invalid coordinates for player_1" do
      player_1_board = Board.new(1)
      player_2_board = Board.new(1)
      game = create(:game, player_1_board: player_1_board, player_2_board: player_2_board)

      json_payload = {target: "B1"}.to_json
      post "/api/v1/games/#{game.id}/shots", params: json_payload, headers: player_1_header

      game_info = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(400)
      expect(game_info[:message]).to eq "Invalid coordinates."
    end

    it "updates the message but not the board with invalid coordinates for player_2" do
      player_1_board = Board.new(1)
      player_2_board = Board.new(1)
      game = create(:game, player_1_board: player_1_board, player_2_board: player_2_board, current_turn: "player_2")

      json_payload = {target: "B1"}.to_json
      post "/api/v1/games/#{game.id}/shots", params: json_payload, headers: player_2_header

      game_info = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(400)
      expect(game_info[:message]).to eq "Invalid coordinates."
    end

    it "updates the message and board with a hit for player_1" do
      ShipPlacer.new(board: player_2_board,
                     ship: sm_ship,
                     start_space: "A1",
                     end_space: "A2").run
      game = create(:game, player_1_board: player_1_board, player_2_board: player_2_board)
      json_payload = {target: "A1"}.to_json
      post "/api/v1/games/#{game.id}/shots", params: json_payload, headers: player_1_header

      expect(response).to be_success

      game_info = JSON.parse(response.body, symbolize_names: true)

      expected_messages = "Your shot resulted in a Hit. "
      player_1_targeted_space = game_info[:player_2_board][:rows].first[:data].first[:status]

      expect(response.status).to eq(200)
      expect(game_info[:message]).to eq expected_messages
      expect(player_1_targeted_space).to eq("Hit")
    end

    it "updates the message and board with a hit for player_2" do
      ShipPlacer.new(board: player_1_board,
                    ship: sm_ship,
                    start_space: "A1",
                    end_space: "A2").run
      game = create(:game, player_1_board: player_1_board, player_2_board: player_2_board, current_turn: "player_2")
      json_payload = {target: "A1"}.to_json

      post "/api/v1/games/#{game.id}/shots", params: json_payload, headers: player_2_header

      expect(response).to be_success

      game_info = JSON.parse(response.body, symbolize_names: true)

      expected_messages = "Your shot resulted in a Hit. "
      player_2_targeted_space = game_info[:player_1_board][:rows].first[:data].first[:status]

      expect(response.status).to eq(200)
      expect(game_info[:message]).to eq expected_messages
      expect(player_2_targeted_space).to eq("Hit")
    end

    it "updates the message when player_1 sinks one but not all of opponents ships" do
      ship = Ship.new(1)
      ShipPlacer.new(board: player_2_board,
                     ship: ship,
                     start_space: "A1",
                     end_space: "A1").run
      ShipPlacer.new(board: player_2_board,
                     ship: ship,
                     start_space: "A2",
                     end_space: "A2").run
      game = create(:game, player_1_board: player_1_board, player_2_board: player_2_board)
      json_payload = {target: "A1"}.to_json

      post "/api/v1/games/#{game.id}/shots", params: json_payload, headers: player_1_header

      expect(response).to be_success

      game_info = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(200)
      expected_messages = "Your shot resulted in a Hit. Battleship sunk."
      expect(game_info[:message]).to eq expected_messages
    end

    it "updates the message when player_2 sinks one but not all of opponents ships" do
      ship = Ship.new(1)
      ShipPlacer.new(board: player_1_board,
                     ship: ship,
                     start_space: "A1",
                     end_space: "A1").run
      ShipPlacer.new(board: player_1_board,
                     ship: ship,
                     start_space: "A2",
                     end_space: "A2").run
      game = create(:game, player_1_board: player_1_board, player_2_board: player_2_board, current_turn: "player_2")
      json_payload = {target: "A1"}.to_json

      post "/api/v1/games/#{game.id}/shots", params: json_payload, headers: player_2_header

      expect(response).to be_success

      game_info = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(200)
      expected_messages = "Your shot resulted in a Hit. Battleship sunk."
      expect(game_info[:message]).to eq expected_messages
    end

    it "updates the message and board when player_1 sinks last of opponents ships" do
      ship = Ship.new(1)
      ShipPlacer.new(board: player_2_board,
                     ship: ship,
                     start_space: "A1",
                     end_space: "A1").run
      game = create(:game, player_1_board: player_1_board, player_2_board: player_2_board)
      json_payload = {target: "A1"}.to_json

      post "/api/v1/games/#{game.id}/shots", params: json_payload, headers: player_1_header

      expect(response).to be_success

      game_info = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(200)
      expected_messages = "Your shot resulted in a Hit. Battleship sunk. Game over."
      expect(game_info[:message]).to eq expected_messages
    end

    it "updates the message and board when player_2 sinks last of opponents ships" do
      ship = Ship.new(1)
      ShipPlacer.new(board: player_1_board,
                     ship: ship,
                     start_space: "A1",
                     end_space: "A1").run
      game = create(:game, player_1_board: player_1_board, player_2_board: player_2_board, current_turn: "player_2")
      json_payload = {target: "A1"}.to_json

      post "/api/v1/games/#{game.id}/shots", params: json_payload, headers: player_2_header

      expect(response).to be_success

      game_info = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(200)
      expected_messages = "Your shot resulted in a Hit. Battleship sunk. Game over."
      expect(game_info[:message]).to eq expected_messages
    end

    it "updates the message when player_1 tries to take a turn on a game that has been completed" do
      ship = Ship.new(1)
      ShipPlacer.new(board: player_2_board,
                     ship: ship,
                     start_space: "A1",
                     end_space: "A1").run
      game = create(:game, player_1_board: player_1_board, player_2_board: player_2_board)
      json_payload = {target: "A1"}.to_json

      post "/api/v1/games/#{game.id}/shots", params: json_payload, headers: player_1_header
      post "/api/v1/games/#{game.id}/shots", params: json_payload, headers: player_1_header

      game_info = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(400)
      expected_messages = "Invalid move. Game over."
      expect(game_info[:message]).to eq expected_messages
    end

    it "updates the message when player_2 tries to take a turn on a game that has been completed" do
      ship = Ship.new(1)
      ShipPlacer.new(board: player_1_board,
                     ship: ship,
                     start_space: "A1",
                     end_space: "A1").run
      game = create(:game, player_1_board: player_1_board, player_2_board: player_2_board, current_turn: "player_2")
      json_payload = {target: "A1"}.to_json

      post "/api/v1/games/#{game.id}/shots", params: json_payload, headers: player_2_header
      post "/api/v1/games/#{game.id}/shots", params: json_payload, headers: player_2_header

      game_info = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(400)
      expected_messages = "Invalid move. Game over."
      expect(game_info[:message]).to eq expected_messages
    end

    it "updates the message when player_2 tries to shoot when it's player_1s turn" do
      ship = Ship.new(1)
      ShipPlacer.new(board: player_2_board,
        ship: ship,
        start_space: "A1",
        end_space: "A1").run
        game = create(:game, player_1_board: player_1_board, player_2_board: player_2_board)
        json_payload = {target: "A1"}.to_json

        post "/api/v1/games/#{game.id}/shots", params: json_payload, headers: player_2_header

        game_info = JSON.parse(response.body, symbolize_names: true)

        expect(response.status).to eq(400)
        expected_messages = "Invalid move. It's your opponent's turn"
        expect(game_info[:message]).to eq expected_messages
      end

    it "updates the message when player_1 tries to shoot when it's player_2s turn" do
      ship = Ship.new(1)
      ShipPlacer.new(board: player_2_board,
                     ship: ship,
                     start_space: "A1",
                     end_space: "A1").run
      game = create(:game, player_1_board: player_1_board, player_2_board: player_2_board, current_turn: "player_2")
      json_payload = {target: "A1"}.to_json

      post "/api/v1/games/#{game.id}/shots", params: json_payload, headers: player_1_header

      game_info = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(400)
      expected_messages = "Invalid move. It's your opponent's turn"
      expect(game_info[:message]).to eq expected_messages
    end

    it "updates the message when user tries to play a game that they are not a part of" do
      ship = Ship.new(1)
      ShipPlacer.new(board: player_1_board,
                     ship: ship,
                     start_space: "A1",
                     end_space: "A1").run
      game = create(:game, player_1_board: player_1_board, player_2_board: player_2_board, current_turn: "player_2")
      unauthorized_user = create(:user)
      unauthorized_user_header = { "CONTENT_TYPE" => "application/json", "HTTP_X_API_KEY" => unauthorized_user.api_key }
      json_payload = {target: "A1"}.to_json

      post "/api/v1/games/#{game.id}/shots", params: json_payload, headers: unauthorized_user_header

      game_info = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(401)
      expected_messages = "Unauthorized"
      expect(game_info[:message]).to eq expected_messages
    end
  end
end
