require 'octokit'

SCHEDULER.every '1m', :first_in => 0 do |job|
  client = Octokit::Client.new()
  repos = client.search_issues("user:ox-it wl- is:open type:pr")
  send_event("pull.requests", { current: repos.total_count })
end
