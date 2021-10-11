class ProjectObserver < ActiveRecord::Observer
  def before_update(updated_project)
    old_date = Project.find(updated_project.id).end_date
    new_date = updated_project.end_date
    return if old_date == new_date
    updated_project.check_alerts(DateTime.new.to_date)

    # movi esto para Proyect
    # if update_alerts_from_project(updated_project)
    #   ActionCable.server.broadcast "web_channel", content: 'A Project is coming to an end'
    # end
  end

  def after_create(project)
    User.all.each { |user| project.add_alert(user) }
  end

  # private
  #
  # def update_alerts_from_project(project)
  #   if !project.end_date.blank? && (project.end_date - Date.parse(Time.now.strftime("%Y-%m-%d"))).to_i <= 7
  #     UserProject.where(project_id: project.id).update_all(notification_active: true, not_seen: true)
  #     true
  #   else
  #     UserProject.where(project_id: project.id).update_all(notification_active: false, not_seen: true)
  #     false
  #   end
  # end

end
