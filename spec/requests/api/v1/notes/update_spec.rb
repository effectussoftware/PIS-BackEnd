describe 'POST api/v1/notes', type: :request do
    let!(:user) { create(:user) }
    let!(:project) { create(:project) }
    let(:text) { 'Mal' }
    let(:texto) { 'Bien' }
    let!(:params) do
        { project_id: project.id, note: {text: text} }
    end
    let!(:params2) do
        { project_id: project.id, note: {text: texto} }
    end

    it 'should return success update' do
        post api_v1_notes_path, params: params, headers: auth_headers, as: :json
        put api_v1_note_path(project.notes[0].id), params: params2, headers: auth_headers, as: :json
        expect(response).to have_http_status(:success)
    end

    it 'should return correct updated params' do
        post api_v1_notes_path, params: params, headers: auth_headers, as: :json
        put api_v1_note_path(project.notes[0].id), params: params2, headers: auth_headers, as: :json
        data = JSON.parse(response.body)
        expect(data["text"]).to eq(texto)
    end

    it 'should not change note count' do
        post api_v1_notes_path, params: params, headers: auth_headers, as: :json
        expect(project.notes.count).to eq(1)
        put api_v1_note_path(project.notes[0].id), params: params2, headers: auth_headers, as: :json
        expect(project.notes.count).to eq(1)
    end

end
