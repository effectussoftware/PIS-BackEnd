# == Schema Information
#
# Table name: user_people
#
#  id                  :bigint           not null, primary key
#  notification_active :boolean          default(FALSE)
#  not_seen            :boolean          default(TRUE)
#  user_id             :integer
#  person_id           :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_user_people_on_person_id  (person_id)
#  index_user_people_on_user_id    (user_id)
#
class UserPerson < Alert
  belongs_to :person

  def obtain_notification
    end_date = person.person_project.find_by(person_id: person.id).maximum(:end_date)
    { id: id, type: 'person', person_id: person.id, name: person.name,
      end_date: end_date }
  end

  def cron_alert
    return unless not_seen

    update!(notification_active: true)
  end

end
