require 'csv'

puts "===== Start Areas Import ====="
ActiveRecord::Base.connection.execute("SET CONSTRAINTS ALL DEFERRED;")

CSV.foreach("db/import/areas.csv") do |row|
  next if row.include?("id")
  area = Area.find_or_initialize_by(id: row[0])
  area.id = row[0]
  area.name = row[1]
  area.latitude = row[5]
  area.longitude= row[6]
  area.save
end

ActiveRecord::Base.connection.execute("SET CONSTRAINTS ALL IMMEDIATE;")
puts "===== End Areas Import ====="
