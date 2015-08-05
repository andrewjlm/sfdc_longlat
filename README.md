Instructions

1. `bundle install`
2. Run the SOQL query `SELECT Account_ID_18__c, ShippingStreet, ShippingCity, ShippingState, ShippingPostalCode, ShippingCountry from Account` and save the results in `data/addresses.csv`.
3. Due to the rate limits on the Google Geocoding API, you'll need to run this for several days (24 hour periods) in a row, 2500 rows at a time:
    # First 2500 lines
    bundle exec ruby find_coordinates.rb
    # Next 2500
    bundle exec ruby find_coordinates.rb -i2500
    # Next 2500...
    bundle exec ruby find_coordinates.rb -i5000
    # etc...
4. You'll end up with several `outputX.csv` files indicating the index each was created with. These can be used to update the latitude and longitude in Salesforce.