class User < ActiveRecord::Base

  has_secure_password

  validates :first_name, :last_name, presence: true
  validates :email, { presence: true, uniqueness: { case_sensitive: false } }
  validates :password, length: { minimum: 4 }

  def self.authenticate_with_credentials(email, password)
    user = User.find_by_email(email.strip.downcase)
    if user && user.authenticate(password)
      return user
    else
      return nil
    end
  end

end
