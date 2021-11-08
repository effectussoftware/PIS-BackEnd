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
  has_many :projects, -> { distinct }, through: :user_projects

  has_many :user_people, dependent: :destroy
  has_many :people, -> { distinct }, through: :user_people

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :trackable, :validatable
  include DeviseTokenAuth::Concerns::User

  validates :uid, uniqueness: { scope: :provider }

  before_validation :init_uid

  after_create do
    Project.all.find_each { |proj| proj.add_alert(self) }
    Person.all.find_each { |per| per.add_alert(self) }
  end

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
    alerts.each do |an_alert|
      an_alert.add_notification(res)
    end
    res
  end

  def update_notification(alert_id, alert_type)
    an_alert = alert alert_id, alert_type
    an_alert.see_notification
  end

  def alerts
    user_people + user_projects
  end

  # :reek:ControlParameter
  def alert(id, alert_type)
    return user_projects.find(id) if alert_type == 'project'
    return user_people.find(id) if alert_type == 'person'

    nil
  end

  # Metodo que corre al conectarse un usuario al channel
  def check_alerts?
    active_notification = false
    alerts.each { |an_alert| active_notification |= an_alert.notifies? }
    active_notification
  end

  private

  def init_uid
    self.uid = email if uid.blank? && provider == 'email'
  end
end
