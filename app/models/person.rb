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
  ROL_TYPES = %w[developer pm tester architect analyst designer].freeze
  has_many :person_technologies, dependent: :destroy
  has_many :technologies, through: :person_technologies
  has_many :person_project, dependent: :destroy
  has_many :projects, -> { distinct }, through: :person_project

  validates :first_name, :last_name, :working_hours,
            presence: { message: I18n.t('api.errors.missing_param') }
  validates :email, uniqueness: true, presence: { message: I18n.t('api.errors.missing_param') }
  validate :check_roles_array, if: -> { roles.any? }

  def add_person_technologies(technologies)
    return if technologies.blank? || !technologies.is_a?(Array)

    res = PersonTechnology.add_person_technologies(id, technologies)
    res.each { |p_t| person_technologies << p_t }
    res
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def rebuild_person_technologies(technologies)
    person_technologies.destroy_all
    add_person_technologies(technologies)
  end

  def check_roles_array
    return if roles.all? { |role| ROL_TYPES.include?(role) }

    errors.add(:roles, I18n.t('api.errors.person.roles_in_list'))
  end
end
