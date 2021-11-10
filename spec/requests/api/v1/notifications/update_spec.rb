describe 'PUT api/v1/notifications', type: :request do
  today = DateTime.now.to_date

  # Needed to get auth_headers
  let!(:user) { create(:user) }
  let!(:unassigned_people) { create_list(:person, 2) }

  # 2 proyectos que si notifican. Terminan en 2 dias (< 7 dias)
  let(:project_notify) do
    create_list(:project, 2, start_date: today - 2.days,
                             end_date: today + 2.days)
  end
  # 3 proyectos que no notifican (fecha fin en 10 dias)
  let!(:project_not_notify) do
    create_list(:project, 3, start_date: today + 1.day,
                             end_date: today + 10.days)
  end
  # Crea 2 personas y las asigna a cada proyecto de assign_noti
  # con una fecha tal que notifica
  let(:assign_noti) do
    people = create_list(:person, 2)
    project_notify.each do |project|
      people.each do |person|
        create(:person_project, person: person, project: project,
                                start_date: project.start_date, end_date: project.end_date)
      end
    end
    people
  end
  # Crea 3 personas y las asigna a cada proyecto en su fecha fin.
  # No notifican porque cada persona tiene al menos un proyecto que termina en mas de 7 dias
  # (No se libera en menos de 7 dias)
  let(:assign_not_noti) do
    people = create_list(:person, 3)
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

  # Crea 5 personas sin proyectos
  let(:only_people) do
    create_list(:person, 5)
  end

  subject { put api_v1_notifications_path(id), headers: auth_headers, as: :json }

  context 'when the parameters are invalid' do
    it 'fails with non existent id' do
      get api_v1_notifications_path, headers: auth_headers, as: :json
      expect(json[:notifications].length).to eq 0

      put api_v1_notification_path(404), headers: auth_headers, as: :json
      expect(json[:error]).not_to be_falsey
    end

    it 'fails if its not my notification' do
      another_user = create(:user)
      #dirty porque llamo una clase dentro de un spec de controller
      dirty_alert = UserProject.where(user_id: another_user.id).first

      put api_v1_notification_path(dirty_alert.id), params: {alert_type: 'project' },
          headers: auth_headers, as: :json

      expect(json[:error]).not_to be_falsey
    end
  end

  context 'when parameters are valid' do
    it 'wont show my notification again' do

    end

    it 'works for project alerts' do

    end

    it 'works for people alerts' do

    end
  end
end
