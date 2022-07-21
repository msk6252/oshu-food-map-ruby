require 'csv'

puts "===== Start Areas Import ====="
ActiveRecord::Base.connection.execute("SET CONSTRAINTS ALL DEFERRED;")

CSV.foreach("db/import/areas.csv") do |row|
  next if row.include?("id")
  area = Area.find_or_initialize_by(id: row[0])
  area.id = row[0]
  area.city_id = row[1]
  area.name= row[2]
  area.save
end

ActiveRecord::Base.connection.execute("SET CONSTRAINTS ALL IMMEDIATE;")
puts "===== End Areas Import ====="
