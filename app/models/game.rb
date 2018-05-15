class Game < ApplicationRecord
  attr_accessor :messages

  enum current_turn: ["player_1", "player_2"]
  serialize :player_1_board
  serialize :player_2_board

  validates :player_1_board, presence: true
  validates :player_2_board, presence: true

  belongs_to :player_1, class_name: 'User'
  belongs_to :player_2, class_name: 'User'

  def self.start(opponent_email, user_api_key)
    game_attributes = {
      player_1_board: Board.new(4),
      player_2_board: Board.new(4),
      player_1_turns: 0,
      player_2_turns: 0,
      current_turn: "player_1",
      player_1_id: User.find_by(api_key: user_api_key).id,
      player_2_id: User.find_by(email: opponent_email).id
    }
    require 'pry'; binding.pry
    Game.new(game_attributes)

  end
end
