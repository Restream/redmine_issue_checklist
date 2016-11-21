require File.expand_path('../../../../test/test_helper', __FILE__)

#Engines::Testing.set_fixture_path
ActiveRecord::Fixtures.create_fixtures(File.dirname(__FILE__) + '/fixtures/',
                                       File.basename('issue_checklists', '.*'))
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
      EnabledModule.create(project: project, name: 'issue_checklist')
    end
  end

end
