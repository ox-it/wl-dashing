require 'net/http'
require 'rubygems'
require 'mechanize'

WEBLEARN_HOMEPAGE = 'https://weblearn.ox.ac.uk/portal'
WEBLEARN_LOGIN_ACTION = 'https://weblearn.ox.ac.uk/portal/relogin'
WEBLEARN_LOGOUT_ACTION = 'https://weblearn.ox.ac.uk/portal/logout'
COURSE_GROUPS_JSON_URL = 'https://weblearn.ox.ac.uk/external-groups/rest/group/browse/?id=courses'
COURSE_GROUPS_AUTH = {
    'name'     => ENV['DASHING_JENKINS_USER'],
    'password' => ENV['DASHING_JENKINS_PASS']
}

def getrespcode()

  a = Mechanize.new
  a.get(WEBLEARN_HOMEPAGE) do |page|

    # Click the login link
    login_page = a.click(page.link_with(:id => 'loginLink2'))

    # Submit login form
    my_page = login_page.form_with(:action => WEBLEARN_LOGIN_ACTION) do |f|
      username_field = f.field_with(:id => 'eid')
      username_field.value = COURSE_GROUPS_AUTH['name']
      password_field = f.field_with(:id => 'pw')
      password_field.value = COURSE_GROUPS_AUTH['password']
    end.click_button

    # Check response code from course groups json
    begin
      page = a.head(COURSE_GROUPS_JSON_URL)
      return page.code;
    rescue Mechanize::ResponseCodeError => exception
      return exception.response_code;
    end

    # Logout
    logout_page = a.get(WEBLEARN_LOGOUT_ACTION)
  end
end

SCHEDULER.every '10s', :first_in => 0 do |job|
  respcode = getrespcode()
  send_event("coursegroups", { respCode: respcode })
end
