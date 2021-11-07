class ProjectObserver < ActiveRecord::Observer
  def before_update(updated_project)
    updated_project.update_alerts
  end

  def after_update(project)
    project.update_person_projects_date
    project.update_person_projects_date_null
  end

  def after_create(project)
    User.all.each { |user| project.add_alert(user) }
  end

  private

  def notifies(end_date)
    return false if end_date.blank?

    (end_date - DateTime.now.to_date).to_i < 7
  end
end
