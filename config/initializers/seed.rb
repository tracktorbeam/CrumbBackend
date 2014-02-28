if Retailer.count == 0

r1 = Retailer.create(retailer_id: '1', name: 'Gymboree')

s = Store.create(internal_store_id: 1, name: 'Laurel Village')
s.create_location(address1: '3407 California Street', 
                  city: 'San Francisco', 
                  state: 'CA', 
                  zip5: 94118, 
                  latitude: 37.786774,
                  longitude: -122.450242)
s.beacons.concat( [Beacon.new(name: 'newborn', uuid: 'E2C56DB5-DFFB-48D2-B060-D0F5A71096E0', major: r1.retailer_id.to_i, minor: 1), Beacon.new(name: 'baby boy', uuid: 'E2C56DB5-DFFB-48D2-B060-D0F5A71096E0', major: r1.retailer_id.to_i, minor: 2), Beacon.new(name: 'baby girl', uuid: 'E2C56DB5-DFFB-48D2-B060-D0F5A71096E0', major: r1.retailer_id.to_i, minor: 3), Beacon.new(name: 'boy', uuid: 'E2C56DB5-DFFB-48D2-B060-D0F5A71096E0', major: r1.retailer_id.to_i, minor: 4), Beacon.new(name: 'girl', uuid: 'E2C56DB5-DFFB-48D2-B060-D0F5A71096E0', major: r1.retailer_id.to_i, minor: 5)] )

r1.stores << s


r2 = Retailer.create(retailer_id: '2', name: 'Hardware Mart')

s = Store.create(internal_store_id: 1, name: 'Daly City')
s.create_location(address1: '303 E Lake Merced Blvd', 
                  city: 'Daly City',
                  state: 'CA',
                  zip5: 94015,
                  latitude: 37.699177,
                  longitude: -122.483750)
s.beacons.concat( [Beacon.new(name: 'refrigerators', uuid: 'E2C56DB5-DFFB-48D2-B060-D0F5A71096E0', major: r2.retailer_id.to_i, minor: 1), Beacon.new(name: 'cooking appliances', uuid: 'E2C56DB5-DFFB-48D2-B060-D0F5A71096E0', major: r2.retailer_id.to_i, minor: 2), Beacon.new(name: 'showers', uuid: 'E2C56DB5-DFFB-48D2-B060-D0F5A71096E0', major: r2.retailer_id.to_i, minor: 3), Beacon.new(name: 'paint samples', uuid: 'E2C56DB5-DFFB-48D2-B060-D0F5A71096E0', major: r2.retailer_id.to_i, minor: 4), Beacon.new(name: 'ceiling fans', uuid: 'E2C56DB5-DFFB-48D2-B060-D0F5A71096E0', major: r2.retailer_id.to_i, minor: 5)] )

r2.stores << s


end

