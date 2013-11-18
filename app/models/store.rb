class Store
  include Mongoid::Document
  field :store_id, type: String
  field :name, type: String
end
