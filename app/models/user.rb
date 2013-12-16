class User < ActiveRecord::Base
  attr_accessible :first_name, :last_name, :email, :company, :title, :role, :password, :password_confirmation

  attr_accessor :password
  before_save :encrypt_password  #ActiveRecord callback

  has_many :locations_users
  has_many :locations, through: :locations_users
  has_many :reports
  has_many :photos, through: :reports

  validates_confirmation_of :password
  validates :password, presence: true, length: { minimum: 6 }, :on => :create
  validates_presence_of :first_name, :on => :create
  validates_presence_of :last_name, :on => :create
  validates :email, uniqueness: true, presence: true, :on => :create



  private
  # the .authenticate User Class method is used by the sessions controller
  def self.authenticate(email, password)
    user = find_by_email(email)
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end
  end

  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end
end
