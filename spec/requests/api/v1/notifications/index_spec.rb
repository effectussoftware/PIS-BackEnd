describe 'GET api/v1/notifications', type: :request do
  # Needed to get auth_headers
  let!(:user) { create(:user) }
  let!(:unassigned_people) { create_list(:person, 2) }

  let(:project_notify) { create_list(:project, 5, start_date: DateTime.now.to_date - 2.days,
                                      end_date: DateTime.now.to_date + 2.days) }
  let!(:project_not_notify) { create_list(:project, 5, start_date: DateTime.now.to_date + 1.days,
                                          end_date: DateTime.now.to_date + 10.days) }

  let(:assign_noti) {
    people = create_list(:person, 5)
    project_notify.each { |project|
      people.each { |person|
        create(:person_project, person: person, project: project,
               start_date: project.start_date, end_date: project.end_date)
      }
    }
    people
  }
  let(:assign_not_noti) {
    people = create_list(:person, 5)
    project_notify.each{ |project|
      people.each{|person|
        create(:person_project, person: person, project: project,
               start_date: project.start_date, end_date: project.end_date)
      }

    }
    project_not_notify.each{ |project|
      people.each{|person|
        create(:person_project, person: person, project: project,
               start_date: project.start_date, end_date: project.end_date)
      }
    }
    people
  }

  let(:only_people){
    people = create_list(:person, 5)
    project_not_notify.each { |project|
      people.each { |person|
        create(:person_project, person: person, project: project,
               start_date: project.start_date, end_date: DateTime.now.to_date + 5.days)
      }
    }
    people
  }

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
