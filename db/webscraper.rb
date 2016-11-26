require 'Nokogiri'
require 'json'
require 'open-uri'
require 'csv'

$states = { "Alabama" => "AL" , "Alaska" => "AK", "Arizona" => "AZ", "Arkansas" => "AR",
"California" => "CA" , "Colorado" => "CO",  "Connecticut" => "CT", "Delaware" => "DE",
"District Of Columbia" => "DC", "Florida" => "FL", "Georgia" => "GA", "Hawaii" => "HI",
"Idaho" => "ID", "Illinois" => "IL", "Indiana" => "IN", "Iowa" => "IA", "Kansas" => "KS",
"Kentucky" => "KY", "Louisiana" => "LA", "Maine" => "ME", "Maryland" => "MD",
"Massachusetts" => "MA", "Michigan" => "MI", "Minnesota" => "MN", "Mississippi" => "MS",
"Missouri" => "MO", "Montana" => "MT", "Nebraska" => "NE", "Nevada" => "NV",
"New Hampshire" => "NH", "New Jersey" => "NJ", "New Mexico" => "NM", "New York" => "NY",
"North Carolina" => "NC", "North Dakota" => "ND", "Ohio" => "OH", "Oklahoma" => "OK",
"Oregon" => "OR", "Pennsylvania" => "PA", "Puerto Rico" => "PR", "Rhode Island" => "RI",
"South Carolina" => "SC", "South Dakota" => "SD", "Tennessee" => "TN", "Texas" => "TX",
"Utah" => "UT",  "Vermont" => "VT", "Virginia" => "VA", "Washington" => "WA",
"West Virginia" => "WV", "Wisconsin" => "WI", "Wyoming" => "WY" }

$all_politicians = []

$denounced = []

def webscrap()

    url = 'http://www.house.gov/representatives/'
    parse_page = Nokogiri::HTML(open(url))
    state_list = parse_page.css("tbody")
    (0..55).each do |i|
        state = $states[parse_page.css("h2")[i+1].text]
        if state_list[i].css("tr")
            state_list[i].css("tr").each do |s|
                name = s.css("td")[1].text.gsub(/\s+/, "")
                party = s.css("td")[2].text
                phone = s.css("td")[4].text

                last_name = name.split(',')[0]
                first_name = name.split(',')[1]
                $all_politicians.push([last_name, first_name, party, phone, state, 'Rep', false])

            end
        end
    end

    senators_url = 'http://www.senate.gov/senators/contact/'
    senate_page = Nokogiri::HTML(open(senators_url))

    for i in (0..299).step(3)
        name = senate_page.css("td.contenttext[align='left']")[i].text.split("\n")[0]
        party = senate_page.css("td.contenttext[align='left']")[i].text.split("\n")[2].gsub(/[^0-9A-Za-z ]/, '').split(" ")[0]
        state = senate_page.css("td.contenttext[align='left']")[i].text.split("\n")[2].gsub(/[^0-9A-Za-z ]/, '').split(" ")[1]
        phone = senate_page.css("td.contenttext[align='left']")[i+1].text

        last_name = name.split(',')[0]
        first_name = name.split(',')[1]
        $all_politicians.push([last_name, first_name, party, phone, state, 'Sen', false])
    end

end

def jstreet_webscrap()
    denounced = []
    url = 'http://jstreet.org/members-congress-condemned-bannons-appointment/'
    parse_page = Nokogiri::HTML(open(url))
    table = parse_page.css("nav.tableOfContents li")
    table.each { |li|
        temp = li.text.strip()[5..-1]
        if temp
          temp = temp.split(" ")
          partial_first = temp[0]
          partial_last = temp[-1]
          $denounced.push([partial_first, partial_last])
        end
    }
end

def matched_stances()
  webscrap()
  jstreet_webscrap()
  $denounced.each do |first, last|
    pol_index = $all_politicians.each_index.select{|i| $all_politicians[i][1].include? first and $all_politicians[i][0].include? last}
    pol_index.each do |i|
      $all_politicians[i][-1] = true
    end
  end
end

def write_to_file()
    matched_stances()
    csv_string = $all_politicians.map(&:to_csv).join
    file = 'politicians.csv'
    IO.write(file, csv_string)
end

write_to_file()
