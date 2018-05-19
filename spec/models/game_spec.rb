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
    end
  end
end
