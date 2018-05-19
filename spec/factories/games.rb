FactoryBot.define do
  factory :game do
    player_1_board "You should add a board object"
    player_2_board "You should add a board object"
    winner nil
    player_1_turns 0
    player_2_turns 0
    # association :player_1, factory: :user
    # association :player_2, factory: :user
    player_1 { create(:user, api_key: "abc") }
    player_2 { create(:user, api_key: "def") }
    current_turn "player_1"
  end
end
