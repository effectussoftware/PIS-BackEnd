# == Schema Information
#
# Table name: user_projects
#
#  id                  :bigint           not null, primary key
#  notification_active :boolean          default(FALSE)
#  not_seen            :boolean          default(TRUE)
#  user_id             :integer
#  project_id          :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
class UserProject < Alert
  belongs_to :project

  def get_notification
    {id: project.id,name: project.name,end_date: project.end_date, type: 'project'}
  end

  def update_notification(val1, val2)
    UserProject.update(notification_update: val1, not_seen: val2)
  end
end
