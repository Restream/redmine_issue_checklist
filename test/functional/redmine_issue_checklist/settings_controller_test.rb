require File.expand_path('../../../test_helper', __FILE__)

class RedmineIssueChecklist::SettingsControllerTest < ActionController::TestCase
  fixtures :users

  def test_plugin_settings
    @controller = SettingsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    User.current = User.find(1)
    @request.session[:user_id] = 1 # admin
    Setting.plugin_redmine_issue_checklist = ''
    get :plugin, id: 'redmine_issue_checklist'
    assert_response :success
  end

end
