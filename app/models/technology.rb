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
class Technology < ApplicationRecord
  # has_many :person_technology, dependent: :destroy
  # has_many :people, through: :person_technology

  validates :name, presence: true
  validates :name, uniqueness: true
  validate :name_is_downcase_and_stripped

  def name_is_downcase_and_stripped
    return if name == name.downcase.strip

    errors.add(:name, I18n.t('api.errors.technology.error_name'))
  end

  # Es importante usar una de las dos find_or_create en vez del create
  def self.find_or_create_single(name)
    name = name.downcase.strip
    technology = Technology.find_by name: name
    return technology unless technology.nil?

    create!(name: name)
  end

  def self.find_or_create_many(names)
    technologies = []
    names.each do |name|
      new_technology = Technology.find_or_create_single(name)
      technologies.push new_technology
    end

    technologies
  end
end
