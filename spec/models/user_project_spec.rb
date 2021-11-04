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
require 'rails_helper'

RSpec.describe UserProject, type: :model do
  describe 'alerts' do
    let!(:user) { create :user }
    let(:project) { create(:project, end_date: (Date.today + 1.days).strftime("%Y-%m-%d") )}

    context 'creates user_projects with corrects bools' do
      it 'create user_project in true-true' do
        up = UserProject.find_by(project_id: project.id, user_id: user.id)
        expect(up.notification_active).to be true
        expect(up.not_seen).to be true
      end
    end
  end
end
