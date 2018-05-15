require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe 'Activation' do
    it 'can send activation email' do
      user = create(:user)
      email = UserMailer.with(user: user).create_activation.deliver_now

      expect(email.to).to eq([user.email])
      expect(email.from).to eq([ENV['default_from']])
      expect(email.subject).to eq('Activate your account')

      expect(email.html_part.body.to_s).to have_content("Visit here to activate your account.")
      expect(email.text_part.body.to_s).to have_content("Visit here to activate your account.")
    end
    it 'activation email has api key' do
      user = create(:user)
      email = UserMailer.with(user: user).create_activation.deliver_now

      expect(email.html_part.body.to_s).to have_content(user.api_key)
      expect(email.text_part.body.to_s).to have_content(user.api_key)
    end
    it 'activation email has activation token' do
      user = create(:user)
      email = UserMailer.with(user: user).create_activation.deliver_now

      expect(email.html_part.body.to_s).to have_content(user.token)
      expect(email.text_part.body.to_s).to have_content(user.token)
    end
  end
end
