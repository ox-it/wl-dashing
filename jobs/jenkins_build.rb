require 'net/http'
require 'json'
require 'time'

JENKINS_URI = URI.parse("http://jenkins.oucs.ox.ac.uk:443")

JENKINS_AUTH = {
  'name'     => ENV['DASHING_JENKINS_USER'],
  'password' => ENV['DASHING_JENKINS_PASS']
}

# the key of this mapping must be a unique identifier for your job, the according value must be the name that is specified in jenkins
job_mapping = {
  '2.8'     => { :job => 'oxford-sakai-2.8.x'},
  '2.8-run' => { :job => 'oxford-sakai-run'},
  '10'      => { :job => 'oxford-sakai-10'},
  '10-run'  => { :job => 'oxford-sakai-10-run'}
}

def get_number_of_failing_tests(job_name)
  info = get_json_for_job(job_name, 'lastCompletedBuild')
  info['actions'][4]['failCount']
end

def get_completion_percentage(job_name)
  build_info = get_json_for_job(job_name)
  prev_build_info = get_json_for_job(job_name, 'lastCompletedBuild')

  return 0 if not build_info["building"]
  last_duration = (prev_build_info["duration"] / 1000).round(2)
  current_duration = (Time.now.to_f - build_info["timestamp"] / 1000).round(2)

  return 99 if current_duration >= last_duration
  ((current_duration * 100) / last_duration).round(0)
end

def get_completion_duration(job_name)
  build_info = get_json_for_job(job_name)
  duration = (Time.now.to_f - build_info["timestamp"] / 1000).round(0)
end

def get_json_for_job(job_name, build = 'lastBuild')
  job_name = URI.encode(job_name)

  http = Net::HTTP.new(JENKINS_URI.host, JENKINS_URI.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE

  request = Net::HTTP::Get.new("/job/#{job_name}/#{build}/api/json")
  if JENKINS_AUTH['name']
    request.basic_auth(JENKINS_AUTH['name'], JENKINS_AUTH['password'])
  end

  response = http.request(request)
  JSON.parse(response.body)
end

job_mapping.each do |title, jenkins_project|
  current_status = nil
  SCHEDULER.every '10s', :first_in => 0 do |job|
    job = jenkins_project[:job]
    build_info = get_json_for_job(job)

    last_status = current_status
    current_status = build_info["result"]

    if build_info["building"]
      current_status = "BUILDING"
      percent = get_completion_percentage(job)
      duration = get_completion_duration(job)
    end

    send_event(title, {
      currentResult: current_status,
      lastResult: last_status,
      timestamp: build_info["timestamp"],
      value: percent,
      duration: duration
    })
  end
end
