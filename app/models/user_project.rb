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

  def obtain_notification
    { id: project.id, name: project.name, end_date: project.end_date, type: 'project' }
  end

  def cron_alert
    return unless not_seen

    update!(notification_active: true)
  end
end
