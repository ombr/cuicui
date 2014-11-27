# User
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :trackable, :validatable, :confirmable,
         :async

  has_many :sites, dependent: :destroy
  has_many :sections, through: :sites
  has_many :images, through: :sections

  def only_if_unconfirmed
    pending_any_confirmation { yield }
  end

  def attempt_set_password(params)
    p = {}
    p[:password] = params[:password]
    p[:password_confirmation] = params[:password]
    update_attributes(p)
  end

  def password?
    encrypted_password_was.present?
  end

  def password_required?
    if !persisted?
      false
    else
      !password.nil? || !password_confirmation.nil?
    end
  end
end
