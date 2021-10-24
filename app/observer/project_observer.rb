class ProjectObserver < ActiveRecord::Observer
  def before_update(updated_project)
    old_date = Project.find(updated_project.id).end_date
    new_date = updated_project.end_date
    return if old_date == new_date

    updated_project.user_projects.each do |up|
      up.update_alert(notifies(new_date))
    end
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
