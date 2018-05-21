require 'rails_helper'

RSpec.describe Game, type: :model do
  describe 'relationships' do
    it { should belong_to :player_1 }
    it { should belong_to :player_2 }
  end
  describe 'instance_methdos' do
    describe 'start' do
      it 'can start a game' do
        user = User.create(email: 'asdf@asdf.com', username: 'asdf', password: 'asdf')
        user.set_keys
        user.save
        opponent = User.create(email: 'qwer@qwer.com', username: 'qwer', password: 'qwer')
        opponent.set_keys
        opponent.save
        game = Game.start(opponent.email, user.api_key)
        expect(Game.last.id).to be(game.id)
      end

      it 'prevents two users from having more than one game in progress at a time' do
        user = User.create(email: 'asdf@asdf.com', username: 'asdf', password: 'asdf')
        user.set_keys
        user.save
        opponent = User.create(email: 'qwer@qwer.com', username: 'qwer', password: 'qwer')
        opponent.set_keys
        opponent.save

        Game.start(opponent.email, user.api_key)

        expect{Game.start(opponent.email, user.api_key)}.to raise_error(InvalidGameCreation)

        Game.last.update(winner: "player_1")

        expect{Game.start(opponent.email, user.api_key)}.not_to raise_error
      end
    end
  end
end
