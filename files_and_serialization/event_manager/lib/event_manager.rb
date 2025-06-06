require 'csv'
require 'erb'
require 'google/apis/civicinfo_v2'
require_relative 'file_handler'

class EventManager
    def initialize(id, first_name, raw_zipcode, raw_phone)
      @id = id
      @first_name = first_name
      @raw_zipcode = raw_zipcode
      @raw_phone = raw_phone
    end

    def create
        legislators = get_legislators_by_zipcode
        phone = clean_phone_numbers(@raw_phone)

        id, first_name, phone = @id, @first_name, @phone

        template_letter = File.read('form_letter.erb')
        erb_template = ERB.new(template_letter)
        form_letter = erb_template.result(binding)
        return form_letter
    end

    private

    def get_legislators_by_zipcode
        zipcode = clean_zipcodes(@raw_zipcode)
        civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
        civic_info.key = File.read('secret.key').strip

        begin
            legislators = civic_info.representative_info_by_address(
                address: zipcode,
                levels: 'country',
                roles: ['legislatorUpperBody', 'legislatorLowerBody']
            ).officials
            # legislators = legislators.officials.map(&:name).join(', ')
            return legislators
        rescue
            puts "Error: Data missing for '#{zipcode}' zipcode."
        end
    end

    def clean_zipcodes(zipcode)
        zipcode.to_s.rjust(5, '0')[0..4] # converte para string e adiciona '0's
    end

    def clean_phone_numbers(phone)
        phone.to_s.gsub(/\D/, '')
        if phone.length == 10
            phone
        elsif phone.length == 11 && phone[0] == '1'
            phone[1..10]
        else
            phone = '0000000000'
        end
        return phone
    end
end

def save_and_say_thanks_into_html(id, form_letter)
    Dir.mkdir('output') unless Dir.exist?('output')
    filename = "output/id_#{id}_.html"

    File.open(filename, 'w') do |file|
        file.puts form_letter
    end
end

file_handler = FileHandler.new("event_attendees.csv")
content = file_handler.create

content.each do |row|
    id = row[0]
    first_name = row[:first_name]
    raw_zipcode = row[:zipcode]
    phone = row[:homephone]

    event_manager = EventManager.new(id, first_name, raw_zipcode, phone)
    
    form_letter = event_manager.create
    save_and_say_thanks_into_html(id, form_letter)
end

