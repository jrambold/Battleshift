require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of :email }
    it { should validate_presence_of :username }
    it { should validate_presence_of :password }
    it { should validate_uniqueness_of :username }
    it { should validate_uniqueness_of :email }
  end

  describe 'class methods' do
    describe '#set_keys and #generate_keys' do
      it 'generate an api key (in combination)' do
        user = User.new(username: 'username', email: 'email@email.com', password: 'password')

        expect(user.api_key).to be_nil

        user.set_keys

        expect(user.api_key).to_not be_nil
      end
      it 'generate a token (in combination)' do
        user = User.new(username: 'username', email: 'email@email.com', password: 'password')

        expect(user.token).to be_nil

        user.set_keys

        expect(user.token).to_not be_nil
      end
    end
    describe 'activate' do
      it 'user can be actitivated with token' do
        user = User.new(username: 'username', email: 'email@email.com', password: 'password')
        user.set_keys
        user.save!

        expect(user.active).to be_falsey

        user.activate(user.token)

        expect(User.last.active).to be_truthy
      end
    end
  end
end
