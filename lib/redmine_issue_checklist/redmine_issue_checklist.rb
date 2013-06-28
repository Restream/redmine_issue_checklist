
require 'redmine_issue_checklist/hooks/views_issues_hook'     
require 'redmine_issue_checklist/hooks/model_issue_hook'     

Rails.configuration.to_prepare do  
	require 'redmine_issue_checklist/patches/issue_patch'     
end

module RedmineIssueChecklist

  def self.settings() Setting[:plugin_redmine_issue_checklist].blank? ? {} : Setting[:plugin_redmine_issue_checklist] end
    
  # module Hooks
  #   class ViewLayoutsBaseHook < Redmine::Hook::ViewListener     
  #     render_on :view_layouts_base_html_head, :inline => "<%= stylesheet_link_tag :contacts_invoices, :plugin => 'redmine_contacts_invoices' %>"
  #   end   
  # end

end

