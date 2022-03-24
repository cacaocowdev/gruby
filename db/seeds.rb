# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

user = User.new({:email => 'test@test', :password => 'testtest'})
if user.save
    puts 'Created user'
else
    puts 'Could not create user'
    user.errors.each {|e| puts e.message}
end