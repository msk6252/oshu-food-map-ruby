require 'csv'

puts "===== Start Genres Import ====="
ActiveRecord::Base.connection.execute("SET CONSTRAINTS ALL DEFERRED;")

CSV.foreach("db/import/genres.csv") do |row|
  next if row.include?("id")
  genre = Genre.new
  genre.id = row[0]
  genre.name= row[1]
  genre.updated_at = Time.now
  genre.created_at = Time.now
  genre.save
end

ActiveRecord::Base.connection.execute("SET CONSTRAINTS ALL IMMEDIATE;")
puts "===== End Genres Import ====="
