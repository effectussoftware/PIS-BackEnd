# == Schema Information
#
# Table name: people
#
#  id            :bigint           not null, primary key
#  first_name    :string           not null
#  last_name     :string           not null
#  email         :string
#  working_hours :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  roles         :text             default([]), is an Array
#
# Indexes
#
#  index_people_on_email  (email) UNIQUE
#
class Person < ApplicationRecord
  has_many :user_person, dependent: :destroy
  has_many :user, through: :user_person

  ROL_TYPES = %w[developer pm tester architect analyst designer].freeze

  has_many :person_technologies, dependent: :destroy
  has_many :technologies, through: :person_technologies
  has_many :person_project, dependent: :destroy
  has_many :projects, -> { distinct }, through: :person_project

  validates :first_name, :last_name, :working_hours,
            presence: { message: I18n.t('api.errors.missing_param') }
  validates :email, uniqueness: true, presence: { message: I18n.t('api.errors.missing_param') }
  validate :check_roles_array, if: -> { roles.any? }

  after_create do
    User.all.find_each { |user| add_alert(user) }
  end

  def add_person_technologies(technologies)
    return if technologies.blank? || !technologies.is_a?(Array)

    res = PersonTechnology.add_person_technologies(id, technologies)
    res.each { |p_t| person_technologies << p_t }
    res
  end

  def rebuild_person_technologies(technologies)
    person_technologies.destroy_all
    add_person_technologies(technologies)
  end

  def check_roles_array
    return if roles.all? { |role| ROL_TYPES.include?(role) }

    errors.add(:roles, I18n.t('api.errors.person.roles_in_list'))
  end

  def add_alert(user)
    end_date = obtain_last_end_date
    up = UserPerson.create!(person_id: id, user_id: user.id)
    up.update_alert(notifies(end_date), end_date.blank? || end_date > DateTime.now.to_date)
  end

  def update_alerts
    end_date = obtain_last_end_date
    user_person.each do |up|
      up.update_alert(notifies(end_date), end_date.blank? || end_date > DateTime.now.to_date)
    end
  end

  def check_alerts
    update_alerts
  end

  def notifies?
    end_date = obtain_last_end_date
    notifies(end_date)
  end

  def notifies(date)
    today = DateTime.now.to_date
    return false if date.blank? || date < today

    (date - today.to_date).to_i < 7
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def obtain_last_end_date
    return if person_project.count.zero?
    return if person_project.where(end_date: nil).count != 0

    person_project.maximum('end_date')
  end
end
