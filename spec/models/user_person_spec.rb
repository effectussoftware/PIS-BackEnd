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

require 'rails_helper'

RSpec.describe UserPerson, type: :model do
  let!(:user) { create(:user) }
  let!(:person) { create(:person) }
  context 'creates user_people with corrects booleans' do
    let!(:project) { create(:project, start_date: DateTime.now.to_date - 2.days) }

    it 'returns true true' do
      create(:person_project, person: person, project: project,
                              start_date: project.start_date, end_date: project.end_date)

      project.update!(end_date: DateTime.now.to_date + 1.day)
      expect(project).to be_valid

      person.add_person_technologies([%w[Java senior]])

      alert = UserPerson.find_by(person_id: person.id, user_id: user.id)

      expect(alert).not_to be_nil
      expect(alert.notification_active).to be_truthy
      expect(alert.not_seen).to be_truthy
      expect(alert.notifies?).to be_truthy
    end

    it 'returns false true' do
      create(:person_project, person: person, project: project,
                              start_date: project.start_date, end_date: project.end_date)

      project.update!(end_date: DateTime.now.to_date + 10.days)
      expect(project).to be_valid

      alert = UserPerson.find_by(person_id: person.id, user_id: user.id)

      expect(alert).not_to be_nil
      expect(alert.notification_active).not_to be_truthy
      expect(alert.not_seen).to be_truthy
      expect(alert.notifies?).not_to be_truthy
    end

    it 'returns false false' do
      create(:person_project, person: person, project: project,
                              start_date: project.start_date, end_date: project.end_date)

      project.update!(end_date: DateTime.now.to_date - 1.day)
      expect(project).to be_valid

      person.add_person_technologies([%w[Java senior]])

      alert = UserPerson.find_by(person_id: person.id, user_id: user.id)

      expect(alert).not_to be_nil
      expect(alert.notification_active).not_to be_truthy
      expect(alert.not_seen).not_to be_truthy
      expect(alert.notifies?).not_to be_truthy
    end
  end

  context 'when person has more than one project' do
    let!(:closing_projects) do
      create_list(:project, 5, start_date: DateTime.now.to_date - 2.days,
                               end_date: DateTime.now.to_date + 5.days)
    end
    let!(:assign_person) do
      closing_projects.each do |project|
        create(:person_project, person: person, project: project,
                                start_date: project.start_date, end_date: project.end_date)
      end
    end

    context 'when theres a nil end date' do
      let!(:nil_end_date) do
        project = create(:project, start_date: DateTime.now.to_date, end_date: nil)
        create(:person_project, person: person, project: project,
                                start_date: project.start_date, end_date: project.end_date)
        project
      end

      it 'returns false true' do
        expect(person.notifies?).to be_falsey

        alert = UserPerson.find_by(person_id: person.id, user_id: user.id)
        expect(alert).not_to be_nil
        expect(alert.notification_active).not_to be_truthy
        expect(alert.not_seen).to be_truthy
        expect(alert.notifies?).not_to be_truthy
      end
    end

    context 'when end date isnt nil' do
      let(:far_away_project) do
        project = create(:project, start_date: DateTime.now.to_date,
                                   end_date: DateTime.now.to_date + 8.days)
        create(:person_project, person: person, project: project,
                                start_date: project.start_date, end_date: project.end_date)
        project
      end

      it 'returns true true' do
        expect(person.notifies?).to be_truthy

        alert = UserPerson.find_by(person_id: person.id, user_id: user.id)
        expect(alert).not_to be_nil
        expect(alert.notification_active).not_to be_truthy
        expect(alert.not_seen).to be_truthy
        expect(alert.notifies?).not_to be_truthy
      end

      it 'returns false true' do
        far_away_project
        expect(person.notifies?).to be_falsey

        alert = UserPerson.find_by(person_id: person.id, user_id: user.id)
        expect(alert).not_to be_nil
        expect(alert.notification_active).not_to be_truthy
        expect(alert.not_seen).to be_truthy
        expect(alert.notifies?).not_to be_truthy
      end
    end
  end
end
