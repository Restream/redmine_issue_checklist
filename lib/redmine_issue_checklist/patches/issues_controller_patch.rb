module RedmineIssueChecklist
  module Patches
    module IssuesControllerPatch
      extend ActiveSupport::Concern

      included do
        alias_method_chain :build_new_issue_from_params, :checklist
      end

      def build_new_issue_from_params_with_checklist
        build_new_issue_from_params_without_checklist
        if User.current.allowed_to?(:edit_checklists, @issue.project)
          @issue.update_checklist_items(params[:check_list_items])
        end
      end
    end
  end
end

unless IssuesController.included_modules.include? RedmineIssueChecklist::Patches::IssuesControllerPatch
  IssuesController.send :include, RedmineIssueChecklist::Patches::IssuesControllerPatch
end
