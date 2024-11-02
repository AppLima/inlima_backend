require_relative 'database'

# models/subject.rb
class Subject < Sequel::Model(DB[:subjects])
    one_to_many :complaints
  end
  
  # models/emergency.rb
  class Emergency < Sequel::Model(DB[:emergencies])
  end
  
  # models/district.rb
  class District < Sequel::Model(DB[:districts])
    one_to_many :citizens
    one_to_many :surveys
    one_to_many :complaints
  end
  
  # models/status.rb
  class Status < Sequel::Model(DB[:statuses])
    one_to_many :complaints
    one_to_many :changes
  end
  
  # models/role.rb
  class Role < Sequel::Model(DB[:roles])
    one_to_many :users
  end
  
  # models/gender.rb
  class Gender < Sequel::Model(DB[:genders])
    one_to_many :users
  end
  
  # models/user.rb
  class User < Sequel::Model(DB[:users])
    many_to_one :role
    many_to_one :gender
    one_to_one :citizen
    one_to_one :administrator
    one_to_many :facial_data
  end
  
  # models/citizen.rb
  class Citizen < Sequel::Model(DB[:citizens])
    many_to_one :user
    many_to_one :district
    one_to_many :responses
    one_to_many :complaints
  end
  
  # models/administrator.rb
  class Administrator < Sequel::Model(DB[:administrators])
    many_to_one :user
    one_to_many :changes
  end
  
  # models/facial_data.rb
  class FacialData < Sequel::Model(DB[:facial_data])
    many_to_one :user
  end
  
  # models/survey.rb
  class Survey < Sequel::Model(DB[:surveys])
    many_to_one :district
    one_to_many :responses
  end
  
  # models/response.rb
  class Response < Sequel::Model(DB[:responses])
    many_to_one :citizen
    many_to_one :survey
  end
  
  # models/complaint.rb
  class Complaint < Sequel::Model(DB[:complaints])
    many_to_one :status
    many_to_one :citizen
    many_to_one :district
    many_to_one :subject
    one_to_many :photos
    one_to_many :changes
  end
  
  # models/photo.rb
  class Photo < Sequel::Model(DB[:photos])
    many_to_one :complaint
  end
  
  # models/change.rb
  class Change < Sequel::Model(DB[:changes])
    many_to_one :administrator
    many_to_one :complaint
    many_to_one :status
  end
  