require 'rails_helper'

RSpec.describe ApplicationCable::Connection, type: :channel do
  today = DateTime.now
  context 'when tokens are correct' do
    let!(:user) { create(:user) }

    it 'successfully connects' do
      connect_user user
      expect(connection.current_user).to eq user
    end

    it 'checks user alerts' do
      # creo un porject a menos de 7 dias de la fecha
      today = DateTime.now
      create(:project, start_date: today, end_date: today + 1)

      expect { connect_user user }
        .to have_broadcasted_to(user).from_channel(WebChannel).exactly(:once)
    end

    it 'allows many users' do
      # TODO: creo un project a menos de 7 dias de la fecha

      create(:project, start_date: today, end_date: today + 1)

      expect { connect_user user }
        .to have_broadcasted_to(user).from_channel(WebChannel).exactly(:once)
    end
  end

  context 'when a project is coming to an end' do
    let!(:user) { create(:user) }
    let(:project) { create(:project) }

    it 'notifies on create' do
      connect_user user
      expect {
        create(:project, start_date: today, end_date: today + 1)
      }.to have_broadcasted_to(user).from_channel(WebChannel).exactly(:once)
    end

    it 'notifies on update' do
      project = create(:project, start_date: today, end_date: today + 8)
      connect_user user
      expect {
        project.update(end_date: today + 1)
      }.to have_broadcasted_to(user).from_channel(WebChannel).exactly(:once)
    end

    it 'notifies seen notif on update' do
      project = create(:project, start_date: today, end_date: today + 1)
      connect_user user

      notifications = user.obtain_notifications
      expect(notifications).not_to be_empty

      user.update_notification(notifications[0][:id], notifications[0][:type])

      # Lo que haria el Job AlertJob
      expect { project.check_alerts }.not_to have_broadcasted_to(user).from_channel(WebChannel)

      expect {
        project.update(end_date: today + 2)
      }.to have_broadcasted_to(user).from_channel(WebChannel).exactly(:once)
    end

    it 'stops notifying on update' do
      project = create(:project, start_date: today, end_date: today + 1)
      connect_user user
      expect(user.obtain_notifications).not_to be_empty

      expect {
        project.update(end_date: today + 9)
      }.not_to have_broadcasted_to(user).from_channel(WebChannel)
      expect(project.end_date).to eq(today.to_date + 9)

      expect { project.check_alerts }.not_to have_broadcasted_to(user).from_channel(WebChannel)

      user.reload # Para que actualice sus user project
      expect(user.obtain_notifications).to be_empty
    end
  end

  context 'tokens are incorrect' do
    let(:non_logged) { create(:user) }
    it 'rejects the connection' do
      expect {
        connect "cable?uid=#{non_logged.email}&client=FakeToken&token=FakeToken"
      }.to have_rejected_connection
    end
  end

  def connect_user(user)
    headers = auth_headers_user user

    connect "cable?uid=#{uid(headers)}" \
            "&client=#{client(headers)}" \
            "&token=#{token(headers)}"
  end

  def uid(headers)
    headers['uid']
  end

  def client(headers)
    headers['client']
  end

  def token(headers)
    headers['access-token']
  end
end
