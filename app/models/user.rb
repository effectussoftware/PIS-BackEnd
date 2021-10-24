# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  allow_password_change  :boolean          default(FALSE)
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  first_name             :string           default("")
#  last_name              :string           default("")
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  provider               :string           default("email"), not null
#  uid                    :string           default(""), not null
#  tokens                 :json
#  needs_password_reset   :boolean          default(TRUE)
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_uid_and_provider      (uid,provider) UNIQUE
#

class User < ApplicationRecord
  has_many :user_projects, dependent: :destroy
  has_many :projects, through: :user_projects

  # TODO: user people
  # has_many :user_people, dependent: :destroy
  # has_many :people, through: :user_people

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :trackable, :validatable
  include DeviseTokenAuth::Concerns::User

  validates :uid, uniqueness: { scope: :provider }

  before_validation :init_uid

  before_create do
    self.needs_password_reset = true
  end

  before_update do
    self.needs_password_reset = false if will_save_change_to_attribute?(:encrypted_password)
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def self.from_social_provider(provider, user_params)
    where(provider: provider, uid: user_params['id']).first_or_create! do |user|
      user.password = Devise.friendly_token[0, 20]
      user.assign_attributes user_params.except('id')
    end
  end

  def obtain_notifications
    res = []
    alerts.each do |a|
      res.push(a.obtain_notification) if a.notifies?
    end
    res
    # return User.joins(:user_projects).find_by(email: uid)
  end

  def update_notification(alert_id, alert_type)
    a = alert alert_id, alert_type
    a.see_notification
  end

  def alerts
    user_projects # + user_people
  end

  def alert(id, alert_type)
    Alert.alert id, alert_type
  end

  # Metodo que corre al conectarse un usuario al channel
  def check_alerts?
    active_notification = false
    alerts.each { |a| active_notification |= a.notifies? }
    active_notification
  end

  private

  def init_uid
    self.uid = email if uid.blank? && provider == 'email'
  end
end
