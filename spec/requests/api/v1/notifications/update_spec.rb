describe 'PUT api/v1/people', type: :request do
  # Needed to get auth_headers
  let!(:user) { create(:user) }
  let!(:person) { create(:person) }
  let!(:person_update) { build(:person) }
  let!(:params) do
    { person: person_update }
  end

  subject { put api_v1_person_path(person.id), params: params, headers: auth_headers, as: :json }

  it 'should return success' do
    subject
    expect(response).to have_http_status(:success)
  end

  it 'should respond proper person as JSON' do
    subject

    id = person[:id]
    full_name = "#{person_update[:first_name]} #{person_update[:last_name]}"

    person_update_reduced = person_update.slice(:first_name, :last_name,
                                                :working_hours, :email, :technologies, :roles)
    person_update_reduced.merge!(id: id, full_name: full_name)
    expect(json[:person]).to eq(person_update_reduced)
  end

  context 'when updating technologies' do
    let(:former_technologies) do
      [
        %w[java
           senior], %w[ruby junior], %w[react semi-senior], %w[psql junior]
      ]
    end
    it 'correctly removes then adds technologies' do
      put api_v1_person_path(person.id),
          params: { person: { technologies: former_technologies } },
          headers: auth_headers, as: :json

      expect(@response).to have_http_status :success
      expect(json[:person][:technologies].size).to eq 4
      json[:person][:technologies].each do |tech|
        expect(tech.in?(former_technologies)).to be_truthy
      end

      new_tech = %w[rails senior]
      put api_v1_person_path(person.id),
          params: { person: { technologies: [new_tech] } },
          headers: auth_headers, as: :json
      expect(@response).to have_http_status :success

      expect(json[:person][:technologies].size).to eq 1
      expect(%w[rails senior].in?(json[:person][:technologies])).to be_truthy
    end
  end

  context 'when patching technologies' do
    former_technologies = [%w[java senior], %w[ruby senior], %w[react senior], %w[psql senior]]
    it 'will override older technologies' do
      put api_v1_person_path(person.id),
          params: { person: { technologies: former_technologies } },
          headers: auth_headers, as: :json
      expect(@response).to have_http_status :success
      expect(json[:person][:technologies].size).to eq 4
      json[:person][:technologies].each do |tech|
        expect(tech.in?(former_technologies)).to be_truthy
      end

      latter_technologies = [%w[ruby junior], %w[react senior], %w[psql senior]]
      patch api_v1_person_path(person.id),
            params: { person: person_update.as_json.merge!(technologies: latter_technologies) },
            headers: auth_headers, as: :json

      expect(@response).to have_http_status :success
      expect(json[:person][:technologies].size).to eq 3
      json[:person][:technologies].each do |tech|
        expect(tech.in?(latter_technologies)).to be_truthy
      end
    end
  end
end
