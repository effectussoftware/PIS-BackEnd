require 'rspec'

describe 'AlertJob' do
  today = DateTime.now.to_date
  let(:distant_projects) do
    create_list(:project, 5,
                start_date: today - 5.days,
                end_date: today + 40.days)
  end
  let(:non_distant_projects) do
    create_list(:project, 3,
                start_date: today - 19.days,
                end_date: today + 3.days)
  end

  let(:assigned_people) { create_list(:person, 4) }
  let(:unassigned_people) { create_list(:person, 2) }

  context 'when there are no projects' do
    it 'succeeds' do
      ActiveJob::Base.queue_adapter = :test
      expect {
        AlertJob.perform_later
      }.to have_enqueued_job
    end
  end

  context 'with only projects' do
    it 'succeeds when projects shouldnt alert' do
      distant_projects
      expect { AlertJob.perform_now }.not_to raise_exception
    end

    it 'succeeds when projects should alert' do
      distant_projects
      non_distant_projects
      expect { AlertJob.perform_now }.not_to raise_exception
    end
  end

  context 'with only people' do
    it 'succeeds' do
      assigned_people
      unassigned_people
      expect { AlertJob.perform_now }.not_to raise_exception
    end
  end

  context 'when projects and people are created' do
    let(:assign_people) do
      assigned_people.each do |person|
        distant_projects.each do |project|
          create(:person_project, person: person, project: project,
                                  start_date: project.start_date,
                                  end_date: project.end_date - 1.day)
        end
      end
      unassigned_people
    end
    it 'succeeds' do
      assign_people
      expect { AlertJob.perform_now }.not_to raise_exception
    end
  end
end
