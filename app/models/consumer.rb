class Consumer
  include Mongoid::Document
  include Mongoid::SortedRelations
  include Mongoid::Timestamps

  field :crumb_id, type: String
  field :sent_offers, type: Array

  has_many :crumbs
  has_many :passes

  def activity(store)
    my_activity = {}

    store.beacons.each do |beacon|
      per_beacon_crumb_ts = self.sorted_crumbs.select {|crumb| (crumb.beacon_id == beacon.id) and crumb.proximity.between?(1, 3) }
      visit_duration_in_secs = 
        per_beacon_crumb_ts.empty? ? 0 : (per_beacon_crumb_ts.last.observed_at - per_beacon_crumb_ts.first.observed_at).round(2)
      my_activity[beacon.id] = visit_duration_in_secs
    end
    
    my_activity
  end

  def first_visit?(retailer)
    self.crumbs.select {|crumb| crumb.beacon.store.retailer_id == retailer.id } .map {|crumb| crumb.observed_at.yday } .uniq.length == 1
  end

  def random_store_visited_in_last_week
    self.crumbs.select {|crumb| crumb.observed_at > (Time.now.utc - 1.week) } .map {|crumb| crumb.beacon.store }.uniq.sample
  end

  def push_any_eligible_offers_to_passes
    get_current_retailer.offers.each do |offer|
      if (!self.sent_offers or !self.sent_offers.to_set.include?(offer.id.to_s))
        if (offer.satisfied_by_consumer(self))
          send_offer_to_pass(offer) 
        end
      end
    end 
  end

  def generate_advertisment
    store = random_store_visited_in_last_week
    if (!store)
      return nil
    end
    
    in_store_activity = activity(store)
    products = in_store_activity.sort_by {|beacon_id, seconds| seconds}.reverse.map do |activity|
                begin
                  if (activity[1] > 0)
                    beacon = Beacon.find(activity[0])
                    beacon.first_party_data.map do |upc|
                      begin
                        Product.find(upc.to_s)
                      rescue
                      end
                    end
                  else
                    []
                  end 
                rescue
                end
              end .flatten 
    {"retailer" => store.retailer.name,
      "products" => products }
  end

  protected
  def get_current_retailer
    self.sorted_crumbs.last.beacon.store.retailer 
  end 
 
  def send_offer_to_pass(offer)
    pass = self.passes.where(retailer_id: offer.retailer.id).first
    if (pass)
      pass.update_pass_with_offer(offer)

      apn = Houston::Client.production
      apn.certificate = File.read(Rails.root.join('passes', offer.retailer.id, offer.retailer.name.downcase + '.pem'))
      pass.devices.each do |device|
        notification = Houston::Notification.new(device: device.push_token)
        apn.push(notification)
      end
      self.update_attribute(:sent_offers, self.sent_offers.nil? ? [offer.id.to_s] : self.sent_offers << offer.id.to_s)
    end
  end

end
