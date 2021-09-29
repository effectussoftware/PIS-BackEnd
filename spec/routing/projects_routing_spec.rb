# == Schema Information
#
# Table name: projects
#
#  id            :bigint           not null, primary key
#  name          :string           not null
#  description   :string           not null
#  start_date    :date             not null
#  end_date      :date
#  budget        :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  project_state :string           not null
#  project_type  :string           not null
#
describe Api::V1::ProjectsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: 'api/v1/projects').to route_to('api/v1/projects#index', format: :json)
    end

    it 'routes to #show' do
      expect(get: 'api/v1/projects/72').to route_to('api/v1/projects#show', format: :json, id: '72')
    end

    it 'routes to #update' do
      expect(put: 'api/v1/projects/25').to route_to('api/v1/projects#update', format: :json, id: '25')
    end

    it 'routes to #delete' do
      expect(delete: 'api/v1/projects/11').to route_to('api/v1/projects#destroy', format: :json,
                                                                              id: '11')
    end

  end
end
