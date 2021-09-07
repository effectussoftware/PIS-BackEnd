class Person < ApplicationRecord
    enum hourly_load: [ :weekely, :daily ]
    validate :hourly_load, inclusion: {in:  Person.hourly_load.keys }
end
