require 'redmine'

require 'dispatcher'

Dispatcher.to_prepare :redmine_project_burndown_callbacks do
  require_dependency 'issue'
  # Guards against including the module multiple time (like in tests)
  # and registering multiple callbacks
  unless Issue.included_modules.include? RedmineProjectBurndownCallbacks::IssuePatch
    Issue.send(:include, RedmineProjectBurndownCallbacks::IssuePatch)
  end
end

Redmine::Plugin.register :redmine_project_burndown_callbacks do
  name 'Redmine Project Burndown Callbacks plugin'
  author 'Expected Behavior'
  author_url 'http://www.expectedbehavior.com'
  description 'This plugin creates time entries and/or tasks at projectburndown.com when issues and time tracking occurs in redmine'
  version '0.0.2'
end
