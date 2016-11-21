require 'redmine_issue_checklist/hooks/views_issues_hook'
require 'redmine_issue_checklist/hooks/model_issue_hook'

Rails.configuration.to_prepare do
  require 'redmine_issue_checklist/patches/issue_patch'
  require 'redmine_issue_checklist/patches/issues_controller_patch'
end

module RedmineIssueChecklist

  def self.settings()
    Setting[:plugin_redmine_issue_checklist].blank? ? {} : Setting[:plugin_redmine_issue_checklist]
  end

end

