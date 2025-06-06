require 'csv'
require 'erb'
require 'google/apis/civicinfo_v2'

# caminho do arquivo hardcoded, mas poderá
# ser dinâmico se virar uma CLI.
FILE_PATH = "event_attendees.csv"

# Para tratar zipcode nulos (nil) convertemos para string;
# O método 'rjust' adiciona 'zeros' no inicio da string (máx 5);
# O 'range' ao final, seleciona do indíce 0 até o 4.
def clean_zipcodes(zipcode)
    zipcode.to_s.rjust(5, '0')[0..4]
end

def get_legislators_by_zipcode(zipcode)
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

# lança um erro se o arquivo/diretório não existir.
unless File.exist?(FILE_PATH)
    raise "No such file or directory: #{FILE_PATH.capitalize}"
end

# abrimos o arquivo com os headers inclusos
# e transformados em symbols.
content = CSV.open(
    FILE_PATH, 
    headers: true, 
    header_converters: :symbol
)

template_letter = File.read('form_letter.erb')
erb_template = ERB.new template_letter

# salva páginas html com os respectivos dados
# de cada participante
def save_and_say_thanks_into_html(id, form_letter)
    Dir.mkdir('output') unless Dir.exist?('output')
    filename = "output/id_#{id}_.html"

    File.open(filename, 'w') do |file|
        file.puts form_letter
    end
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

# exibimos os dados selecionados e formatados.
content.each do |row|
    id = row[0]
    first_name = row[:first_name]
    zipcode = clean_zipcodes(row[:zipcode])
    legislators = get_legislators_by_zipcode(zipcode)
    phone = clean_phone_numbers(row[:homephone])
    puts row
    form_letter = erb_template.result(binding)
    save_and_say_thanks_into_html(id, form_letter)
end
