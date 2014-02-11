if Retailer.count == 0

r = Retailer.create(retailer_id: '1', name: 'Gymboree')

s1 = Store.create(internal_store_id: 1, name: 'Laurel Village')
s1.create_location(address1: '3407 California Street', 
                  city: 'San Francisco', 
                  state: 'CA', 
                  zip5: 94118, 
                  latitude: 37.786774,
                  longitude: -122.450242)
s1.beacons.concat( [Beacon.new(name: 'newborn', uuid: 'E2C56DB5-DFFB-48D2-B060-D0F5A71096E0', major: r.retailer_id.to_i, minor: 1), Beacon.new(name: 'baby boy', uuid: 'E2C56DB5-DFFB-48D2-B060-D0F5A71096E0', major: r.retailer_id.to_i, minor: 2), Beacon.new(name: 'baby girl', uuid: 'E2C56DB5-DFFB-48D2-B060-D0F5A71096E0', major: r.retailer_id.to_i, minor: 3), Beacon.new(name: 'boy', uuid: 'E2C56DB5-DFFB-48D2-B060-D0F5A71096E0', major: r.retailer_id.to_i, minor: 4), Beacon.new(name: 'girl', uuid: 'E2C56DB5-DFFB-48D2-B060-D0F5A71096E0', major: r.retailer_id.to_i, minor: 5)] )

r.stores << s1

s2 = Store.create(internal_store_id: 2, name: 'Stonestown Galleria')
s2.create_location(address1: '3251 20th Avenue', 
                  city: 'San Francisco', 
                  state: 'CA', 
                  zip5: 94132, 
                  latitude: 37.727909,
                  longitude: -122.476383)
s2.beacons.concat( [Beacon.new(name: 'newborn', uuid: 'E2C56DB5-DFFB-48D2-B060-D0F5A71096E0', major: r.retailer_id.to_i, minor: 6), Beacon.new(name: 'baby boy', uuid: 'E2C56DB5-DFFB-48D2-B060-D0F5A71096E0', major: r.retailer_id.to_i, minor: 7), Beacon.new(name: 'baby girl', uuid: 'E2C56DB5-DFFB-48D2-B060-D0F5A71096E0', major: r.retailer_id.to_i, minor: 8), Beacon.new(name: 'boy', uuid: 'E2C56DB5-DFFB-48D2-B060-D0F5A71096E0', major: r.retailer_id.to_i, minor: 9), Beacon.new(name: 'girl', uuid: 'E2C56DB5-DFFB-48D2-B060-D0F5A71096E0', major: r.retailer_id.to_i, minor: 10)])

r.stores << s2

end

