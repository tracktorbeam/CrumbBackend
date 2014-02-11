class Store
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :internal_store_id, type: String
  field :name, type: String

  embeds_one :location
  has_many :beacons
  belongs_to :retailer
  
end


class Location
  include Mongoid::Document
  
  field :address1, type: String
  field :address2, type: String
  field :city, type: String
  field :state, type: String
  field :zip5, type: Integer
  field :zip4, type: Integer
  field :country, type: String, default: 'USA'
  
  field :latitude, type: BigDecimal
  field :longitude, type: BigDecimal
  
  embedded_in :store

end
