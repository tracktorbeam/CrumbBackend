class Beacon
  include Mongoid::Document
  include Mongoid::Timestamps
  validates :first_party_data, array: { format: { with: /\d/ , message: "UPC needs to be numeric"}}

  after_save :fetch_product_data

  field :_id, type: String, default: ->{ uuid + '|' + major.to_s + '|' + minor.to_s }
  field :name, type: String  

  field :uuid, type: String
  field :major, type: Integer
  field :minor, type: Integer

  field :first_party_data, type: Array, default: [] 

  has_many :crumbs
  belongs_to :store  


  def first_party_data=(upc)
    upcs = self.first_party_data.nil? ? [upc] : (self.first_party_data << upc).uniq
    write_attribute(:first_party_data, upcs)
  end

  def ==(other_beacon)
    self.id == other_beacon.id
  end

  protected

  def fetch_product_data
    self.first_party_data.each { |upc| Product.find_or_create_by(upc: upc.to_s) } 
  end

end
