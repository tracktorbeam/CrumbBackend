class Beacon
  include Mongoid::Document
#  validates :beacon_id, presence: true
#  validates :store, presence: true
#  validates :first_party_data, array: { format: { with: /\d/ , message: "UPC needs to be numeric"}}

  field :beacon_id, type: String
  field :_id, type: String, default: ->{ beacon_id }
  field :name, type: String  

  field :uuid, type: String
  field :major, type: Integer
  field :minor, type: Integer

  field :first_party_data, type: Array

  has_many :crumbs
  belongs_to :store  


  def first_party_data=(upc)
    upcs = (self.first_party_data.nil? ? [upc] : (self.first_party_data << upc)).uniq
    write_attribute(:first_party_data, upcs)
  end


  def ==(other_beacon)
    self.beacon_id == other_beacon.beacon_id
  end

end
