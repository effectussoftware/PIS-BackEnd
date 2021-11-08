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
    end_date = person.obtain_last_end_date
    { alert_id: id, alert_type: 'person', id: person.id, name: person.full_name,
      end_date: end_date }
  end
end
