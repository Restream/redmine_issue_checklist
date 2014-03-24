# This file is a part of redmine_tags
# redMine plugin, that adds tagging support.
#
# Copyright (c) 2010 Eric Davis
# Copyright (c) 2010 Aleksey V Zapparov AKA ixti
#
# redmine_tags is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# redmine_tags is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with redmine_tags.  If not, see <http://www.gnu.org/licenses/>.

module RedmineIssueChecklist
  module Hooks
    class ModelIssueHook < Redmine::Hook::ViewListener

      def controller_issues_edit_before_save(context={})
        if User.current.allowed_to?(:edit_checklists, context[:issue].project)
          save_checklist_to_issue(context, RedmineIssueChecklist.settings[:save_log])
        end
      end

      def controller_issues_new_after_save(context={})
        if User.current.allowed_to?(:edit_checklists, context[:issue].project)
          save_checklist_to_issue(context, false)
          context[:issue].save
        end
      end

      def save_checklist_to_issue(context, create_journal)
        issue = context[:issue]
        checklist_items = context[:params] && context[:params][:check_list_items]
        issue.update_checklist_items(checklist_items, create_journal) if issue && checklist_items
      end

    end
  end
end
