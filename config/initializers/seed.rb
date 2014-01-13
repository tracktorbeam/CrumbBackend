if Retailer.count == 0

r = Retailer.new(retailer_id: '1', name: 'Gymboree')
r.save

s1 = Store.new(internal_store_id: 1, name: 'Laurel Village')
s1.build_location(address1: '3407 California Street', 
                  city: 'San Francisco', 
                  state: 'CA', 
                  zip5: 94118, 
                  latitude: 37.786774,
                  longitude: -122.450242)
s1.beacons = [ Beacon.new(beacon_id: 'E2C56DB5-DFFB-48D2-B060-D0F5A71096E0_' + r.retailer_id + '_1', name: 'newborn', uuid: 'E2C56DB5-DFFB-48D2-B060-D0F5A71096E0', major: r.retailer_id.to_i, minor: 1), Beacon.new(beacon_id: 'E2C56DB5-DFFB-48D2-B060-D0F5A71096E0_' + r.retailer_id + '_2', name: 'baby boy', uuid: 'E2C56DB5-DFFB-48D2-B060-D0F5A71096E0', major: r.retailer_id.to_i, minor: 2), Beacon.new(beacon_id: 'E2C56DB5-DFFB-48D2-B060-D0F5A71096E0_' + r.retailer_id + '_3', name: 'baby girl', uuid: 'E2C56DB5-DFFB-48D2-B060-D0F5A71096E0', major: r.retailer_id.to_i, minor: 3), Beacon.new(beacon_id: 'E2C56DB5-DFFB-48D2-B060-D0F5A71096E0_' + r.retailer_id + '_4', name: 'boy', uuid: 'E2C56DB5-DFFB-48D2-B060-D0F5A71096E0', major: r.retailer_id.to_i, minor: 4), Beacon.new(beacon_id: 'E2C56DB5-DFFB-48D2-B060-D0F5A71096E0_' + r.retailer_id + '_5', name: 'girl', uuid: 'E2C56DB5-DFFB-48D2-B060-D0F5A71096E0', major: r.retailer_id.to_i, minor: 5) ]

r.stores << s1

s2 = Store.new(internal_store_id: 2, name: 'Stonestown Galleria')
s2.build_location(address1: '3251 20th Avenue', 
                  city: 'San Francisco', 
                  state: 'CA', 
                  zip5: 94132, 
                  latitude: 37.727909,
                  longitude: -122.476383)
s2.beacons = [ Beacon.new(beacon_id: 'E2C56DB5-DFFB-48D2-B060-D0F5A71096E0_' + r.retailer_id + '_6', name: 'newborn', uuid: 'E2C56DB5-DFFB-48D2-B060-D0F5A71096E0', major: r.retailer_id.to_i, minor: 6), Beacon.new(beacon_id: 'E2C56DB5-DFFB-48D2-B060-D0F5A71096E0_' + r.retailer_id + '_7', name: 'baby boy', uuid: 'E2C56DB5-DFFB-48D2-B060-D0F5A71096E0', major: r.retailer_id.to_i, minor: 7), Beacon.new(beacon_id: 'E2C56DB5-DFFB-48D2-B060-D0F5A71096E0_' + r.retailer_id + '_8', name: 'baby girl', uuid: 'E2C56DB5-DFFB-48D2-B060-D0F5A71096E0', major: r.retailer_id.to_i, minor: 8), Beacon.new(beacon_id: 'E2C56DB5-DFFB-48D2-B060-D0F5A71096E0_' + r.retailer_id + '_9', name: 'boy', uuid: 'E2C56DB5-DFFB-48D2-B060-D0F5A71096E0', major: r.retailer_id.to_i, minor: 9), Beacon.new(beacon_id: 'E2C56DB5-DFFB-48D2-B060-D0F5A71096E0_' + r.retailer_id + '_10', name: 'girl', uuid: 'E2C56DB5-DFFB-48D2-B060-D0F5A71096E0', major: r.retailer_id.to_i, minor: 10) ]

r.stores << s2

end
