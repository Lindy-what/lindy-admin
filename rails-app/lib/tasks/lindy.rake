namespace :lindy do
  desc "Adds members and registers them to courses"
  task seed: :environment do
    Course.all.each do |course|
      print "seeding #{course.title}\n"
      30.times do
        name = Faker::Name.name
        space = name.index(" ")
        firstname = name[0..space-1]
        lastname = name[space+1..-1]
        member = Member.create!({firstname: firstname, lastname: lastname, email: Faker::Internet.email, address: Faker::Address.street_address})

        registration = Registration.new
        registration.course = course
        registration.member = member
        registration.ticket = course.tickets.sample
        registration.role = [true, false].sample
        registration.save!
      end
    end
    print "done\n"
  end

end