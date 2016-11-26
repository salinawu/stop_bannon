require 'csv'
def make_hash(row)
  return {last_name:row[0], first_name:row[1], party:row[2], phone:row[3], state:row[4], position:row[5], denounced:row[6]}
end

namespace :politicians do
  desc "TODO"
  task populate: :environment do
    csv = 'politicians.csv'

    CSV.foreach('politicians.csv', :headers => false) do |row|
      Politician.create!(make_hash(row))
    end
  end

end
