class User < ApplicationRecord
  has_secure_password
  validates :email, :username, presence: true, uniqueness: true
  validates :password, presence: true, on: :create

  has_many :player_1s, class_name: 'Game', foreign_key: 'player_1_id', dependent: :destroy
  has_many :player_2s, class_name: 'Game', foreign_key: 'player_2_id', dependent: :destroy

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
