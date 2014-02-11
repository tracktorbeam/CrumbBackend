class Retailer
  include Mongoid::Document
  include Mongoid::Timestamps

  field :retailer_id, type: String
  field :_id, type: String, default: ->{ retailer_id }
  field :name, type: String
  field :original_price, type: Float
  field :discounted_price, type: Float
       

  has_many :stores
  has_many :passes
  has_many :offers

end
