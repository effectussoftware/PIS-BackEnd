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
  context 'creates user_projects with corrects booleans when create project' do
    let!(:user) { create(:user) }
    it 'returns true true' do
      project = create(:project, start_date: DateTime.now.to_date - 2.days,
                                 end_date: DateTime.now.to_date + 1.day)
      up = UserProject.find_by(project_id: project.id, user_id: user.id)
      expect(up.notification_active).to be_truthy
      expect(up.not_seen).to be_truthy
    end

    it 'returns false true' do
      project = create(:project, start_date: DateTime.now.to_date - 2.days,
                                 end_date: DateTime.now.to_date + 10.days)
      up = UserProject.find_by(project_id: project.id, user_id: user.id)
      expect(up.notification_active).not_to be_truthy
      expect(up.not_seen).to be_truthy
    end
    it 'returns false false' do
      project = create(:project, start_date: DateTime.now.to_date - 2.days,
                                 end_date: DateTime.now.to_date - 1.day)
      up = UserProject.find_by(project_id: project.id, user_id: user.id)
      expect(up.notification_active).not_to be_truthy
      expect(up.not_seen).not_to be_truthy
    end
  end

  context 'creates user_projects with corrects booleans when create user' do
    it 'returns true true' do
      project = create(:project, start_date: DateTime.now.to_date - 2.days,
                                 end_date: DateTime.now.to_date + 1.day)
      user = create(:user)
      up = UserProject.find_by(project_id: project.id, user_id: user.id)
      expect(up.notification_active).to be_truthy
      expect(up.not_seen).to be_truthy
    end

    it 'returns false true' do
      project = create(:project, start_date: DateTime.now.to_date - 2.days,
                                 end_date: DateTime.now.to_date + 10.days)
      user = create(:user)
      up = UserProject.find_by(project_id: project.id, user_id: user.id)
      expect(up.notification_active).not_to be_truthy
      expect(up.not_seen).to be_truthy
    end

    it 'returns false false' do
      project = create(:project, start_date: DateTime.now.to_date - 2.days,
                                 end_date: DateTime.now.to_date - 1.day)
      user = create(:user)
      up = UserProject.find_by(project_id: project.id, user_id: user.id)
      expect(up.notification_active).not_to be_truthy
      expect(up.not_seen).not_to be_truthy
    end
  end

  context 'when project updated' do
    let!(:user) { create(:user) }
    let(:project) { create(:project) }
    it 'returns true true' do
      project.end_date = DateTime.now.to_date + 1.day
      project.update_alerts
      up = UserProject.find_by(project_id: project.id, user_id: user.id)
      expect(up.notification_active).to be_truthy
      expect(up.not_seen).to be_truthy
    end
    it 'returns false true' do
      project.end_date = DateTime.now.to_date + 10.days
      project.update_alerts
      up = UserProject.find_by(project_id: project.id, user_id: user.id)
      expect(up.notification_active).not_to be_truthy
      expect(up.not_seen).to be_truthy
    end
    it 'returns false false' do
      project.start_date = DateTime.now.to_date - 2.days
      project.end_date = DateTime.now.to_date - 1.day
      project.update_alerts
      up = UserProject.find_by(project_id: project.id, user_id: user.id)
      expect(up.notification_active).not_to be_truthy
      expect(up.not_seen).not_to be_truthy
    end
  end
  context 'when project or user deleted' do
    let!(:user) { create(:user) }
    let(:project) { create(:project) }
    it 'object user_project nil through project' do
      p_id = project.id
      project.destroy!
      expect(UserProject.find_by(project_id: p_id, user_id: user.id)).to be_nil
    end
    it 'object user_project nil through user' do
      u_id = user.id
      user.destroy!
      expect(UserProject.find_by(project_id: project, user_id: u_id)).to be_nil
    end
  end

  context 'when end_date is nil' do
    let!(:user) { create(:user) }
    it 'should return false true' do
      project = create(:project, start_date: DateTime.now.to_date - 2.days, end_date: nil)
      up = UserProject.find_by(project_id: project.id, user_id: user.id)
      expect(up.notification_active).not_to be_truthy
      expect(up.not_seen).to be_truthy
    end
  end
end
