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
# Indexes
#
#  index_user_projects_on_project_id  (project_id)
#  index_user_projects_on_user_id     (user_id)
#
class UserProject < Alert
  belongs_to :project

  def obtain_notification
    { id: id, type: 'project', project_id: project.id, name: project.name,
      end_date: project.end_date }
  end

  def cron_alert
    return unless not_seen

    update!(notification_active: true)
  end
end
