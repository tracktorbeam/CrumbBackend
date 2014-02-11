class Device
  include Mongoid::Document
  include Mongoid::Timestamps
  
  has_and_belongs_to_many :passes

  field :device_library_identifier, type: String
  field :push_token, type: String

end
