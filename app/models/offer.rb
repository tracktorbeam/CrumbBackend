class Offer
  include Mongoid::Document
  include Mongoid::Timestamps
  validates_uniqueness_of :product, message: "Offer exists for this beacon"
  validates_numericality_of :discount, only_integer: true
  validates_numericality_of :trigger, only_integer: true

  belongs_to :retailer

  field :product, type: String, default: "newborn"
  field :discount, type: Integer
  field :trigger, type: Integer
  
  field :primary_label, type: String, default: "DISCOUNT"
  field :primary_value, type: String, default: ->{ discount.to_s + "% off : " + product.titlecase }
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
      activity[beacon.id] > self.trigger
    end
  end 

end
