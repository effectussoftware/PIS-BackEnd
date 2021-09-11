# == Schema Information
#
# Table name: projects
#
#  id          :bigint           not null, primary key
#  name        :string           not null
#  description :string
#  start_date  :date             not null
#  end_date    :date             not null
#  budget      :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require 'rails_helper'

RSpec.describe Project, type: :model do
  describe 'validations' do
    let(:project) { build(:project) }

    it 'test that factory is valid' do
      expect(project).to be_valid
    end


    context 'when fields are invalid' do

      # No pude hacer que valide que las fechas incorrectas
      # de invalido porque valida cuando le tiro create y
      # me tira la excepcion

    end

    context 'when fields are valid' do
      it 'has valid dates' do
        project1 = create(:project,
                          :start_date => '2021-09-10',
                          :end_date => '2021-09-11')
        expect(project1).to be_valid
      end
    end

  end
end
