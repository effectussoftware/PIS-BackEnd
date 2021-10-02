class ProjectObserver < ActiveRecord::Observer
  def before_update(updated_project)
    old_date = Project.find(updated_project.id).end_date
    new_date = updated_project.end_date
    return if old_date == updated_project.end_date
    update_alerts_from_project(updated_project)
  end

  def after_create(project)
    @users = User.all
    @users.each { |elem|
      UserProject.create(project_id: project.id, user_id: elem[:id])
    }
    update_alerts_from_project(project)
  end

  private

  def update_alerts_from_project(project)
    if !project.end_date.blank? && (project.end_date - Date.parse(Time.now.strftime("%Y-%m-%d"))).to_i <= 7
      UserProject.where(project_id: project.id).update_all(notify: true, isvalid: true)
    else
      UserProject.where(project_id: project.id).update_all(notify: false, isvalid: true)
    end
  end

end
