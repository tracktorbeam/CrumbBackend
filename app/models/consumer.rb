class Consumer
  include Mongoid::Document
#  validates :consumer_id, presence: true

  field :consumer_id, type: String
  field :_id, type: String, default: ->{ consumer_id }

  has_many :crumbs


  def activity(store)
    my_activity = {}
    my_crumbs_indexed_by_doy = self.crumbs.group_by{ |crumb| crumb.created_at.yday }
    latest_crumbs = my_crumbs_indexed_by_doy[my_crumbs_indexed_by_doy.keys.sort.last]
    
    store.beacons.each do |beacon|
      per_beacon_crumb_ts = latest_crumbs.select {|crumb| crumb.beacon_id == beacon.beacon_id} .sort! { |a,b| a.created_at <=> b.created_at }
      visit_duration_in_secs = 
        per_beacon_crumb_ts.empty? ? 0 : (per_beacon_crumb_ts.last.created_at - per_beacon_crumb_ts.first.created_at).round(2)
      my_activity[beacon.beacon_id] = visit_duration_in_secs
    end
    
    my_activity
  end

end
