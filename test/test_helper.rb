require File.expand_path(File.dirname(__FILE__) + '/../../../../test/test_helper')
# require 'redgreen'  

Engines::Testing.set_fixture_path    

class RedmineIssueChecklist::TestCase       
  def self.prepare
    Role.find(1, 2, 3, 4).each do |r| 
      r.permissions << :edit_checklists
      r.save
    end
    
    Role.find(3, 4).each do |r| 
      r.permissions << :done_checklists
      r.save
    end 
    
    Project.find(1, 2, 3, 4, 5).each do |project| 
      EnabledModule.create(:project => project, :name => 'issue_checklist')
    end
  end   
  
end