require_dependency 'mailer'

module RedmineIssueChecklist
  module Patches

    module MailerPatch

      def self.included(base) # :nodoc:
        base.send(:include, InstanceMethods)
        base.class_eval do
          alias_method_chain :issue_add, :checklist
          alias_method_chain :issue_edit, :checklist
        end

      end

      module InstanceMethods

        def issue_add_with_checklist(issue, to_users, cc_users)
          issue_add_without_checklist(issue, to_users, cc_users)
        end

        def issue_edit_with_checklist(issue, to_users, cc_users)
          issue_edit_without_checklist(issue, to_users, cc_users)
        end
      end

    end

  end
end


unless Mailer.included_modules.include?(RedmineIssueChecklist::Patches::MailerPatch)
  Mailer.send(:include, RedmineIssueChecklist::Patches::MailerPatch)
end
