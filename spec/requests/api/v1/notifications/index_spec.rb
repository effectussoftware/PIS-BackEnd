describe 'GET api/v1/notifications', type: :request do
  # Needed to get auth_headers
  let!(:user) { create(:user) }
  let!(:unassigned_people) { create_list(:person, 2) }

  let(:project_notify) do
    create_list(:project, 5, start_date: DateTime.now.to_date - 2.days,
                             end_date: DateTime.now.to_date + 2.days)
  end
  let!(:project_not_notify) do
    create_list(:project, 5, start_date: DateTime.now.to_date + 1.day,
                             end_date: DateTime.now.to_date + 10.days)
  end

  let(:assign_noti) do
    people = create_list(:person, 5)
    project_notify.each do |project|
      people.each do |person|
        create(:person_project, person: person, project: project,
                                start_date: project.start_date, end_date: project.end_date)
      end
    end
    people
  end
  let(:assign_not_noti) do
    people = create_list(:person, 5)
    project_notify.each do |project|
      people.each do |person|
        create(:person_project, person: person, project: project,
                                start_date: project.start_date, end_date: project.end_date)
      end
    end
    project_not_notify.each do |project|
      people.each do |person|
        create(:person_project, person: person, project: project,
                                start_date: project.start_date, end_date: project.end_date)
      end
    end
    people
  end

  let(:only_people) do
    people = create_list(:person, 5)
    project_not_notify.each do |project|
      people.each do |person|
        create(:person_project, person: person, project: project,
                                start_date: project.start_date, end_date: DateTime.now.to_date +
            5.days)
      end
    end
    people
  end

  subject { get api_v1_notifications_path, headers: auth_headers, as: :json }

  context 'when no project or person notifies' do
    it 'returns 0 notifications' do
      subject
      expect(response).to have_http_status(:success)
      expect(json[:notifications].length).to eq 0
    end
  end

  context 'when some projects notify' do
    it 'returns 5 notifications' do
      project_notify
      subject

      expect(response).to have_http_status(:success)
      expect(json[:notifications].length).to eq 5
    end

    context 'when the projects have assignations' do
      it 'returns 10 notifications' do
        assign_not_noti
        assign_noti
        subject

        expect(response).to have_http_status(:success)
        expect(json[:notifications].length).to eq 10
      end
    end
  end

  context 'no projects, only people' do
    it 'return 5' do
      only_people
      subject
      expect(json[:notifications].length).to eq 5
    end
  end
end
