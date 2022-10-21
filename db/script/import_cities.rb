require 'csv'

puts "===== Start Cities Import ====="
ActiveRecord::Base.connection.execute("SET CONSTRAINTS ALL DEFERRED;")

CSV.foreach("db/import/cities.csv") do |row|
  next if row.include?("id")
  city = City.find_or_initialize_by(id: row[0])
  city.id = row[0]
  city.name= row[1]
  city.save
end

ActiveRecord::Base.connection.execute("SET CONSTRAINTS ALL IMMEDIATE;")
puts "===== End Cities Import ====="
