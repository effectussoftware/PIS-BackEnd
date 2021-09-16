# == Schema Information
#
# Table name: people
#
#  id                :bigint           not null, primary key
#  first_name        :string           not null
#  last_name         :string           not null
#  email             :string
#  hourly_load       :string
#  hourly_load_hours :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_people_on_email  (email) UNIQUE
#
describe Api::V1::PeopleController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: 'api/v1/people').to route_to('api/v1/people#index', format: :json)
    end

    it 'routes to #show' do
      expect(get: 'api/v1/people/72').to route_to('api/v1/people#show', format: :json, id: '72')
    end

    it 'routes to #update' do
      expect(put: 'api/v1/people/25').to route_to('api/v1/people#update', format: :json, id: '25')
    end

    it 'routes to #delete' do
      expect(delete: 'api/v1/people/11').to route_to('api/v1/people#destroy', format: :json,
                                                                              id: '11')
    end
  end
end
