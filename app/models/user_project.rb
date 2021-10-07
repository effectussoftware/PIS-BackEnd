# == Schema Information
#
# Table name: user_projects
#
#  id         :bigint           not null, primary key
#  notify     :boolean          default(FALSE)
#  is_valid   :boolean          default(TRUE)
#  user_id    :integer
#  project_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class UserProject < ApplicationRecord
  belongs_to :user
  belongs_to :project
end
