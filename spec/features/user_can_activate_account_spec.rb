require 'rails_helper'

describe 'User' do
  describe 'fills out a registration form and goes to activation link' do
    it 'and it activates an account' do
      visit '/register'

      fill_in 'user[email]', with: 'email@example.com'
      fill_in 'user[username]', with: 'username'
      fill_in 'user[password]', with: 'password'
      fill_in 'user[password_confirmation]', with: 'password'
      click_on 'Create User'

      user = User.last

      expect(user.active).to be_falsey

      visit "/activate?id=#{user.id}&token=#{user.token}"

      expect(User.last.active).to be_truthy

    end
    it 'does not activate with bad token' do
      visit '/register'

      fill_in 'user[email]', with: 'email@example.com'
      fill_in 'user[username]', with: 'username'
      fill_in 'user[password]', with: 'password'
      fill_in 'user[password_confirmation]', with: 'password'
      click_on 'Create User'

      user = User.last

      expect(user.active).to be_falsey

      visit "/activate?id=#{user.id}&token=asdf"

      expect(User.last.active).to be_falsey

    end
  end
end
