class Person < ApplicationRecord
    enum hourly_load: [ :weekely, :daily ]
    validates :hourly_load, inclusion: { in: Person.hourly_loads.keys }
end
