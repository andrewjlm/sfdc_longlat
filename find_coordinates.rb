require 'rubygems'
require 'bundler/setup'
require 'csv'
require 'openssl'
require 'optparse'

require 'geocoder'

# Array to fill with hashes of ID and long/lat
longlat = []

# Read starting index from command line
index = 0
OptionParser.new do |opts|
  opts.banner = "Usage: find_coordinates.rb [options]"
  opts.on("-iINDEX", Integer, "Index to start from") do |n|
    index = n
  end
end.parse!

stopLine = index + 2500

# Read all the lines except the first
CSV.foreach('data/addresses.csv', headers:true).with_index(1) do |row, rowno|
  # Concatenate date fields into an address
  full_address = [row[1], row[2], row[3], row[4], row[5]].join(' ')
  id = row[0]
  # If we're in the relevant range of addresses...
  if (rowno > index and rowno <= stopLine)
    # Search the address in whatever geocoding service
    d = Geocoder.search(full_address)

    # If nil is returned we assume the address wasn't found
    if !d[0].nil?
      # Extract the longitude and latitude
      ll = d[0].data["geometry"]["location"]
      # Insert hash into array
      longlat << {:id => id, :full_address => full_address, :lat => ll['lat'], :lng => ll['lng']}
    end

    # Wait a 5th of a second so we don't go over the Google API query limit
    sleep(0.2)
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

outname = 'output' << index.to_s << '.csv'

File.write(outname, output)