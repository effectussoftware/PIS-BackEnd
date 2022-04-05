describe 'DELETE api/v1/notes', type: :request do
    let!(:user) { create(:user) }
    let!(:project2) { create(:project) }
    let(:text) { 'Bien' }
    let!(:params) do
        { project_id: project2.id, note: {text: text} }
    end

    it 'should return success destroy' do
        post api_v1_notes_path, params: params, headers: auth_headers, as: :json
        delete api_v1_note_path(project2.notes[0].id), headers: auth_headers, as: :json
        expect(response).to have_http_status(:success)
    end

    it 'should return 0 count' do
        expect(project2.notes.count).to eq(0)
        post api_v1_notes_path, params: params, headers: auth_headers, as: :json
        expect(project2.notes.count).to eq(1)
        delete api_v1_note_path(project2.notes[0].id), headers: auth_headers, as: :json
        expect(project2.notes.count).to eq(0)
    end

end