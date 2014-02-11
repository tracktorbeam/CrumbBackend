class Offer
  include Mongoid::Document
  include Mongoid::Timestamps
  validates_presence_of :product

  belongs_to :retailer

  field :product, type: String
  
  field :primary_label, type: String, default: "DISCOUNT"
  field :primary_value, type: String, default: ->{ "50% off : " + product.titlecase }
  field :primary_change_message, type: String, default: ->{ "%@" } 

  field :expiration_label, type: String, default: "EXPIRES"
  field :expiration_value, type: Time
  field :expiration_is_relative, type: Boolean, default: true
  field :expiration_time_style, type: String, default: "PKDateStyleShort"

  def expiration_value
    Time.now.utc + 1.hour 
  end

  def satisfied_by_consumer(consumer)
    store = self.retailer.stores.first
    activity = consumer.activity(store)
    beacon = store.beacons.where(name: self.product).first
    if (beacon)
      activity[beacon.id] > 600
    end
  end 

end
