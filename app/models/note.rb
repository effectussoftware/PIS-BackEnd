# == Schema Information
#
# Table name: notes
#
#  id         :bigint           not null, primary key
#  text       :string           not null
#  project_id :bigint
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_notes_on_project_id  (project_id)
#
class Note < ApplicationRecord
    belongs_to :project
end
