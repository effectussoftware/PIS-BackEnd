# == Schema Information
#
# Table name: technologies
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_technologies_on_name  (name) UNIQUE
#
require 'rails_helper'

RSpec.describe Technology, type: :model do
  let(:technology) { build(:technology) }

  it 'test that factory is valid' do
    expect(technology).to be_valid
  end

  context 'when parameters are valid' do
    it 'creates missing technologies' do
      names = ['Missing 1', 'Missing 2', 'Missing 3']
      techs = Technology.find_or_create_many(names)
      expect(techs.size == 3).to be_truthy
      names = names.map { |n| n.downcase.strip }
      techs.each { |tech| expect(tech.name.in?(names)) }
    end

    it 'finds or creates' do
      name = 'Java'
      expect(Technology.find_by(name: name)).to be_nil

      # Si lo busco una vez quiero que devuelva una instancia
      tech1 = Technology.find_or_create_single(name)
      expect(tech1).not_to be_nil
      expect(tech1).to be_valid
      # Si lo busco la segunda vez quiero que sea la misma instancia
      expect(Technology.find_or_create_single(name).id == tech1.id).to be_truthy
    end

    it 'downcase and strips on find or create' do
      tech1 = Technology.find_or_create_single('  UPPERJava ')
      expect(tech1).to be_valid
      expect(tech1.name == 'upperjava').to be_truthy
    end
  end

  context 'when parameters are invalid' do
    it 'the same name is invalid' do
      technology_rep = create(:technology)
      expect(technology_rep).to be_valid

      technology.name = technology_rep.name
      expect(technology).not_to be_valid
    end
  end
end
