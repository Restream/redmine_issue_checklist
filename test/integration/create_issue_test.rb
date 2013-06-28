require File.dirname(__FILE__) + '/../test_helper'  
require File.dirname(__FILE__) + '/../../../../../test/test_helper' 

class CreateIssueTest < ActionController::IntegrationTest
  fixtures :all, :contacts,
    :contacts_projects,
    :deals,
    :notes,
    :tags,
    :taggings
    
  def setup
    RedmineIssueChecklist::TestCase.prepare

    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.env['HTTP_REFERER'] = '/'
  end  
  
  test "Checklist should be created with new issue" do
    log_user("admin", "admin")
    
    assert_not_nil User.first
    
    post "ecookbook/issues" 
   end  
end