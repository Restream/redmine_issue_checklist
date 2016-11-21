require 'redmine'

require 'redmine_issue_checklist/redmine_issue_checklist'

Redmine::Plugin.register :redmine_issue_checklist do
  name 'Redmine Issue Checklist Plugin'
  author 'Kirill Bezrukov'
  description 'This plugin adds checklists to Redmine issues.'
  version '2.1.0'
  url 'http://redminecrm.com'
  author_url 'mailto:kirbez@redminecrm.com'

  requires_redmine version_or_higher: '2.0.0'

  settings default: {
    save_log:         false,
    issue_done_ratio: false
  }, partial:       'settings/issue_checklist'

  Redmine::AccessControl.map do |map|
    map.project_module :issue_tracking do |map|
      map.permission :view_checklists, {}
      map.permission :done_checklists, { issue_checklist: :done }
      map.permission :edit_checklists, { issue_checklist: :delete, issue_checklist: :done }
    end
  end

end
