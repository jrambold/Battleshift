require 'rails_helper'

describe "Api::V1::Shots" do
  context "POST /api/v1/games/:id/shots" do
    let(:player_1_board)   { Board.new(4) }
    let(:player_2_board)   { Board.new(4) }
    let(:sm_ship) { Ship.new(2) }

    it "updates the message and board with a miss for player_1" do
      # allow_any_instance_of(AiSpaceSelector).to receive(:fire!).and_return("Miss")
      game = create(:game, player_1_board: player_1_board, player_2_board: player_2_board)
      headers = { "CONTENT_TYPE" => "application/json" }
      json_payload = {target: "A1"}.to_json
      post "/api/v1/games/#{game.id}/shots", params: json_payload, headers: headers

      expect(response).to be_success

      game_info = JSON.parse(response.body, symbolize_names: true)

      expected_messages = "Your shot resulted in a Miss. "
      player_1_targeted_space = game_info[:player_2_board][:rows].first[:data].first[:status]

      expect(game_info[:message]).to eq expected_messages
      expect(player_1_targeted_space).to eq("Miss")
    end

    it "updates the message and board with a miss for both player_2" do
      game = create(:game, player_1_board: player_1_board, player_2_board: player_2_board, current_turn: "player_2")
      headers = { "CONTENT_TYPE" => "application/json" }
      json_payload = {target: "A1"}.to_json
      post "/api/v1/games/#{game.id}/shots", params: json_payload, headers: headers

      expect(response).to be_success

      game_info = JSON.parse(response.body, symbolize_names: true)

      expected_messages = "Your shot resulted in a Miss. "
      player_2_targeted_space = game_info[:player_1_board][:rows].first[:data].first[:status]

      expect(game_info[:message]).to eq expected_messages
      expect(player_2_targeted_space).to eq("Miss")
    end

    it "updates the message but not the board with invalid coordinates for player_1" do
      player_1_board = Board.new(1)
      player_2_board = Board.new(1)
      game = create(:game, player_1_board: player_1_board, player_2_board: player_2_board)

      headers = { "CONTENT_TYPE" => "application/json" }
      json_payload = {target: "B1"}.to_json
      post "/api/v1/games/#{game.id}/shots", params: json_payload, headers: headers

      game_info = JSON.parse(response.body, symbolize_names: true)
      expect(game_info[:message]).to eq "Invalid coordinates."
    end

    it "updates the message but not the board with invalid coordinates for player_2" do
      player_1_board = Board.new(1)
      player_2_board = Board.new(1)
      game = create(:game, player_1_board: player_1_board, player_2_board: player_2_board, current_turn: "player_2")

      headers = { "CONTENT_TYPE" => "application/json" }
      json_payload = {target: "B1"}.to_json
      post "/api/v1/games/#{game.id}/shots", params: json_payload, headers: headers

      game_info = JSON.parse(response.body, symbolize_names: true)
      expect(game_info[:message]).to eq "Invalid coordinates."
    end


    it "updates the message and board with a hit for both player_1" do
      # allow_any_instance_of(AiSpaceSelector).to receive(:fire!).and_return("Miss")
      ShipPlacer.new(board: player_1_board,
                    ship: sm_ship,
                    start_space: "A1",
                    end_space: "A2").run
      ShipPlacer.new(board: player_2_board,
                     ship: sm_ship,
                     start_space: "A1",
                     end_space: "A2").run
      game = create(:game, player_1_board: player_1_board, player_2_board: player_2_board)
      headers = { "CONTENT_TYPE" => "application/json" }
      json_payload = {target: "A1"}.to_json
      post "/api/v1/games/#{game.id}/shots", params: json_payload, headers: headers

      expect(response).to be_success

      game_info = JSON.parse(response.body, symbolize_names: true)

      expected_messages = "Your shot resulted in a Hit. "
      player_1_targeted_space = game_info[:player_2_board][:rows].first[:data].first[:status]

      expect(game_info[:message]).to eq expected_messages
      expect(player_1_targeted_space).to eq("Hit")
    end

    it "updates the message and board with a hit for both player_1" do
      ShipPlacer.new(board: player_1_board,
                    ship: sm_ship,
                    start_space: "A1",
                    end_space: "A2").run
      ShipPlacer.new(board: player_2_board,
                     ship: sm_ship,
                     start_space: "A1",
                     end_space: "A2").run
      game = create(:game, player_1_board: player_1_board, player_2_board: player_2_board, current_turn: "player_2")
      headers = { "CONTENT_TYPE" => "application/json" }
      json_payload = {target: "A1"}.to_json

      post "/api/v1/games/#{game.id}/shots", params: json_payload, headers: headers

      expect(response).to be_success

      game_info = JSON.parse(response.body, symbolize_names: true)

      expected_messages = "Your shot resulted in a Hit. "
      player_2_targeted_space = game_info[:player_1_board][:rows].first[:data].first[:status]

      expect(game_info[:message]).to eq expected_messages
      expect(player_2_targeted_space).to eq("Hit")
    end

    it "updates the message and board when player_1 sinks a ship" do
      # allow_any_instance_of(AiSpaceSelector).to receive(:fire!).and_return("Miss")
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
      headers = { "CONTENT_TYPE" => "application/json" }
      json_payload = {target: "A1"}.to_json

      post "/api/v1/games/#{game.id}/shots", params: json_payload, headers: headers

      expect(response).to be_success

      game_info = JSON.parse(response.body, symbolize_names: true)

      expected_messages = "Your shot resulted in a Hit. Battleship sunk."
      expect(game_info[:message]).to eq expected_messages
    end

    it "updates the message and board when player_2 sinks a ship" do
      # allow_any_instance_of(AiSpaceSelector).to receive(:fire!).and_return("Miss")
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
      headers = { "CONTENT_TYPE" => "application/json" }
      json_payload = {target: "A1"}.to_json

      post "/api/v1/games/#{game.id}/shots", params: json_payload, headers: headers

      expect(response).to be_success

      game_info = JSON.parse(response.body, symbolize_names: true)

      expected_messages = "Your shot resulted in a Hit. Battleship sunk."
      expect(game_info[:message]).to eq expected_messages
    end

    it "updates the message and board when player_1 sinks last of opponents ships" do
      # allow_any_instance_of(AiSpaceSelector).to receive(:fire!).and_return("Miss")
      ship = Ship.new(1)
      ShipPlacer.new(board: player_2_board,
                     ship: ship,
                     start_space: "A1",
                     end_space: "A1").run
      game = create(:game, player_1_board: player_1_board, player_2_board: player_2_board)
      headers = { "CONTENT_TYPE" => "application/json" }
      json_payload = {target: "A1"}.to_json

      post "/api/v1/games/#{game.id}/shots", params: json_payload, headers: headers

      expect(response).to be_success

      game_info = JSON.parse(response.body, symbolize_names: true)

      expected_messages = "Your shot resulted in a Hit. Battleship sunk. Game over."
      expect(game_info[:message]).to eq expected_messages
    end

    it "updates the message and board when player_2 sinks last of opponents ships" do
      # allow_any_instance_of(AiSpaceSelector).to receive(:fire!).and_return("Miss")
      ship = Ship.new(1)
      ShipPlacer.new(board: player_1_board,
                     ship: ship,
                     start_space: "A1",
                     end_space: "A1").run
      game = create(:game, player_1_board: player_1_board, player_2_board: player_2_board, current_turn: "player_2")
      headers = { "CONTENT_TYPE" => "application/json" }
      json_payload = {target: "A1"}.to_json

      post "/api/v1/games/#{game.id}/shots", params: json_payload, headers: headers

      expect(response).to be_success

      game_info = JSON.parse(response.body, symbolize_names: true)

      expected_messages = "Your shot resulted in a Hit. Battleship sunk. Game over."
      expect(game_info[:message]).to eq expected_messages
    end

    it "updates the message and board when player_1 tries to take a turn on a game that has been completed" do
      # allow_any_instance_of(AiSpaceSelector).to receive(:fire!).and_return("Miss")
      ship = Ship.new(1)
      ShipPlacer.new(board: player_2_board,
                     ship: ship,
                     start_space: "A1",
                     end_space: "A1").run
      game = create(:game, player_1_board: player_1_board, player_2_board: player_2_board)
      headers = { "CONTENT_TYPE" => "application/json" }
      json_payload = {target: "A1"}.to_json

      post "/api/v1/games/#{game.id}/shots", params: json_payload, headers: headers
      post "/api/v1/games/#{game.id}/shots", params: json_payload, headers: headers

      game_info = JSON.parse(response.body, symbolize_names: true)

      expected_messages = "Invalid move. Game over."
      expect(game_info[:message]).to eq expected_messages
    end

    it "updates the message and board when player_2 tries to take a turn on a game that has been completed" do
      # allow_any_instance_of(AiSpaceSelector).to receive(:fire!).and_return("Miss")
      ship = Ship.new(1)
      ShipPlacer.new(board: player_1_board,
                     ship: ship,
                     start_space: "A1",
                     end_space: "A1").run
      game = create(:game, player_1_board: player_1_board, player_2_board: player_2_board, current_turn: "player_2")
      headers = { "CONTENT_TYPE" => "application/json" }
      json_payload = {target: "A1"}.to_json

      post "/api/v1/games/#{game.id}/shots", params: json_payload, headers: headers
      post "/api/v1/games/#{game.id}/shots", params: json_payload, headers: headers

      game_info = JSON.parse(response.body, symbolize_names: true)

      expected_messages = "Invalid move. Game over."
      expect(game_info[:message]).to eq expected_messages
    end
  end
end
