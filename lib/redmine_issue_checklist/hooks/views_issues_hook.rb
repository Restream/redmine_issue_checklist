module RedmineIssueChecklist
  module Hooks
    class ViewsIssuesHook < Redmine::Hook::ViewListener     
      render_on :view_issues_show_description_bottom, :partial => "issues/checklist"	
      render_on :view_issues_form_details_bottom, :partial => "issues/checklist_form"
    end   
  end
end
