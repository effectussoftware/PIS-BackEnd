describe 'POST api/v1/notes', type: :request do
    let!(:user) { create(:user) }
    let!(:project) { create(:project) }
    let(:text) { 'Muy buena' }
    let!(:params) do
        { project_id: project.id, note: {text: text} }
    end

    it 'should return success' do
        post api_v1_notes_path, params: params, headers: auth_headers, as: :json
        expect(response).to have_http_status(:success)
    end

    context 'working with params' do
        
        it 'should return correct params' do
            post api_v1_notes_path, params: params, headers: auth_headers, as: :json
            data = JSON.parse(response.body)
            expect(data["text"]).to eq(text)
        end

        it 'should add another note to project' do
            post api_v1_notes_path, params: params, headers: auth_headers, as: :json
            expect(project.notes.count).to eq(1)
            post api_v1_notes_path, params: params, headers: auth_headers, as: :json
            expect(project.notes.count).to eq(2)
        end
    end
end
