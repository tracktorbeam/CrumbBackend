class Retailer
  include Mongoid::Document
  validates :retailer_id, presence: true

  field :retailer_id, type: String
  field :_id, type: String, default: ->{ retailer_id }
  field :name, type: String

  has_many :stores, dependent: :delete

end
