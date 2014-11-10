require 'net/http'
require 'json'
# require 'time'

# This just grabs all the data from status.ox

STATUS_URI = URI.parse("http://status.ox.ac.uk/")

# Just get the JSON returned from the server.
def get_json()

  http = Net::HTTP.new(STATUS_URI.host, STATUS_URI.port)
  http.use_ssl = false
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE

  request = Net::HTTP::Get.new("/api/services.json")

  response = http.request(request)
  JSON.parse(response.body)
end

SCHEDULER.every '30s', :first_in => 0 do |job|
  build_info = get_json()
  send_event("status", { data: build_info})
end
