# == Schema Information
#
# Table name: projects
#
#  id            :bigint           not null, primary key
#  name          :string           not null
#  description   :string           not null
#  start_date    :date             not null
#  end_date      :date
#  budget        :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  project_state :string           not null
#  project_type  :string           not null
#  organization  :string
#
# Indexes
#
#  index_projects_on_name  (name) UNIQUE
#
class Project < ApplicationRecord
  has_many :user_projects, dependent: :destroy
  has_many :users, through: :user_projects

has_many :project_technologies, dependent: :destroy
  has_many :technologies, through: :project_technologies

  has_many :person_project, dependent: :destroy
  has_many :people, -> { distinct }, through: :person_project

  PROJECT_TYPES = %w[staff_augmentation end_to_end tercerizado hibrido].freeze
  PROJECT_STATES = %w[rojo amarillo verde upcoming].freeze

  FILTER_PARAMS = %w[project_state project_type organization].freeze
  ARRAY_FILTER_PARAMS = %w[technologies].freeze
  validates :name, presence: { message: I18n.t('api.errors.missing_param') }
  validates :description,
            presence: { message: I18n.t('api.errors.missing_param') }
  validates :start_date,
            presence: { message: I18n.t('api.errors.missing_param') }
  validates :project_type, inclusion: { in: Project::PROJECT_TYPES },
                           presence: { message: I18n.t('api.errors.missing_param') }
  validates :project_state, inclusion: { in: Project::PROJECT_STATES },
                            presence: { message: I18n.t('api.errors.missing_param') }
  validates :name, uniqueness: true
  validate :budget_is_valid
  validate :end_date_is_after_start_date

  after_update :update_person_projects_date
  after_update :update_person_projects_date_null
  #TODO agregar al observer
  def update_person_projects_date
    person_projects = PersonProject.where('project_id = :project_id
      AND start_date < :start_date', { project_id: id, start_date: start_date })
    update_person_projects(person_projects, :start_date, start_date)

    person_projects = PersonProject.where('project_id = :project_id
      AND end_date > :end_date', { project_id: id, end_date: end_date })
    update_person_projects(person_projects, :end_date, end_date)
  end

  def update_person_projects_date_null
    return if end_date.blank?

    person_projects = PersonProject.where('project_id = :project_id
      AND end_date is null', { project_id: id, end_date: end_date })
    update_person_projects(person_projects, :end_date, end_date)
  end

  def update_person_projects(person_projects, date, update)
    person_projects.each do |p_p|
      p_p[date] = update
      p_p.save!
    end
  end

  def add_project_technologies(technologies)
    return if technologies.blank? || !technologies.is_a?(Array)

    res = ProjectTechnology.add_project_technologies(id, technologies)
    res.each { |p_t| project_technologies << p_t }
    res
  end

  def rebuild_project_technologies(technologies)
    project_technologies.destroy_all
    add_project_technologies(technologies)
  end

  scope :by_technologies, lambda { |techs|
    if techs.blank?
      itself
    else
      joins(:technologies).where(
        techs.map { 'technologies.name = ?' }
             .reduce { |recursive, elem| "#{recursive} or #{elem}" },
        *techs
      ).includes(:technologies)
      # Este includes hace que no se repitan proyectos en el join
    end
  }
  scope :by_project_state, lambda { |project_state|
                             if project_state.blank?
                               itself
                             else
                               where(projects: { project_state: project_state })
                             end
                           }
  scope :by_project_type, lambda { |project_type|
                            if project_type.blank?
                              itself
                            else
                              where(projects: { project_type: project_type })
                            end
                          }
  scope :by_organization, lambda { |organization|
                            if organization.blank?
                              itself
                            else
                              where('lower(organization) like ?', "#{organization.downcase}%")
                            end
                          }

  def self.filter(filters)
    Project.by_technologies(filters['technologies'])
           .by_project_state(filters['project_state'])
           .by_project_type(filters['project_type'])
           .by_organization(filters['organization'])

    # .order("#{filters['column']} #{filters['direction']}")
  end

=begin
    Para cada alerta hago lo siguiente:
    Si ya falta menos de 7 dias, la alerta ya esta activa y no se actualiza (solo se notifica si corresponde)
    Si faltan 7 dias o mas se debe verificar que la alerta este en estado correcto, se ejecuta actualizar_estado
=end
  def check_alerts
    # actual_date = DateTime.new.to_date
    return if end_date.blank?

    # days_difference = (end_date - actual_date)
    user_projects.each do |up|
      if notifies?
        up.cron_alert
        up.check_alert
      end
    end
  end

  def update_alerts
    user_projects.each do |up|
      up.update_alert(notifies?)
    end
  end

  def add_alert(user)
    up = UserProject.create!(project_id: id, user_id: user.id)
    up.update_alert(notifies?)
  end

  def notifies?
    return false if end_date.blank?

    (end_date - DateTime.now.to_date).to_i < 7
  end

  def update_person_projects
    person_projects = PersonProject.where('project_id = :project_id
        AND start_date < :start_date', { project_id: id, start_date: start_date })
    update_person_project_date(person_projects, :start_date, start_date)

    person_projects = PersonProject.where('project_id = :project_id
      AND end_date > :end_date', { project_id: id, end_date: end_date })

    update_person_project_date(person_projects, :end_date, end_date)
  end

  def update_person_project_date(person_projects, date, update)
    person_projects.each do |p_p|
      p_p[date] = update
      p_p.save!
    end
  end

  def update_alerts(notifies)
    user_projects.each do |up|
      up.update_alert(notifies)
    end
  end

=begin
    Para cada alerta hago lo siguiente:
    Si ya falta menos de 7 dias, la alerta ya esta activa y no se actualiza (solo se notifica si corresponde)
    Si faltan 7 dias o mas se debe verificar que la alerta este en estado correcto, se ejecuta actualizar_estado
=end
  def check_alerts
    actual_date = DateTime.new.to_date
    return if end_date.blank?
    days_difference = (end_date - actual_date)
    user_projects.each do |up|
      if days_difference < 7
        up.check_alert
      else
        up.update_alert(notifies?)
      end
    end
  end

  def add_alert(user)
    up = UserProject.create!(project_id: id, user_id: user.id)
    up.update_alert(self.notifies?)
  end

  def notifies?
    return false if end_date.blank?
    (end_date - DateTime.now.to_date < 7.days)
  end
  
  private

  def budget_is_valid
    return if budget.blank?

    return unless budget.negative?

    errors.add(:budget, I18n.t('api.errors.project.invalid_budget'))
  end

  def end_date_is_after_start_date
    return if end_date.blank? || start_date.blank?

    return unless end_date < start_date

    errors.add(:end_date, I18n.t('api.errors.project.end_date_before_start_date'))
  end
end
