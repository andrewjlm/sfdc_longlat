require 'rubygems'
require 'bundler/setup'
require 'csv'
require 'openssl'

require 'geocoder'

# Array to fill with hashes of ID and long/lat
longlat = []

# Read all the lines except the first
CSV.foreach('data/addresses.csv', headers:true) do |row|
  # Concatenate date fields into an address
  full_address = [row[1], row[2], row[3], row[4], row[5]].join(' ')
  id = row[0]

  # Search the address in whatever geocoding service
  d = Geocoder.search(full_address)
  # If nil is returned we assume the address wasn't found
  if !d[0].nil?
    # Extract the longitude and latitude
    ll = d[0].data["geometry"]["location"]
    # Insert hash into array
    longlat << {:id => id, :full_address => full_address, :lat => ll['lat'], :lng => ll['lng']}
  end
end

# Write output CSV with SFDC ID and Long/lat
column_names = longlat.first.keys

output = CSV.generate do |csv|
  csv << column_names
  longlat.each do |x|
    csv << x.values
  end
end

File.write('output.csv', output)