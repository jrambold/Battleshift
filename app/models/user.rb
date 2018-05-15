class User < ApplicationRecord
  has_secure_password
  validates :email, :username, presence: true, uniqueness: true
  validates :password, presence: true, on: :create

  def activate(url_token)
    if url_token == self.token
      self.update!(active: true)
    end
  end

  def set_keys
    self.api_key = generate_key
    self.token = generate_key
  end

  private
    def generate_key
      SecureRandom.urlsafe_base64
    end
end
