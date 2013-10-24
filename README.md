# Redmine Checklist plugin

[![Build Status](https://travis-ci.org/Undev/redmine_issue_checklist.png?branch=master)](https://travis-ci.org/Undev/redmine_issue_checklist)
[![Code Climate](https://codeclimate.com/github/Undev/redmine_issue_checklist.png)](https://codeclimate.com/github/Undev/redmine_issue_checklist)

Extends issues to store checklist items
Developed by Kirill Bezrukov
http://www.redminecrm.com/projects/checklist/pages/1

## Installation

Unzip it into ../plugins/. This would result in a directory-path like:

    ../plugins/redmine_issue_checklist/init.rb

or clone it from the redmine directory:

    git clone https://github.com/Undev/redmine_issue_checklist.git plugins/redmine_issue_checklist

Migrate database and copy assets by following command:

    bundle exec rake redmine:plugins NAME=redmine_issue_checklist RAILS_ENV=production

You now need to restart Redmine so that it shows the newly installed plugin in the list of installed plugins ("Administration -> Plugins").
Go to "Administration -> Plugins -> Redmine Issues Checklist plugin" and setup plugin global settings.

## Test

    rake redmine:plugins:test NAME=redmine_issue_checklist RAILS_ENV=test_sqlite3

## License

Redmine Checklist plugin is open source and released under the terms of the GNU General Public License v2 (GPL).
