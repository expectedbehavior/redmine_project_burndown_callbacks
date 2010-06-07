module RedmineProjectBurndownCallbacks

  # patch in some after_save filter action
  module IssuePatch
    def self.included(base)
      base.extend(ClassMethods)
      
      base.send(:include, InstanceMethods)
      
      base.class_eval do
        unloadable # Send unloadable so it will not be unloaded in development
        after_create  :create_project_burndown_story
        after_update  :update_project_burndown_story
        after_destroy :destroy_project_burndown_story
      end
    end
  end
  

  module ClassMethods
    def sync_with_project_burndown
      Issues.all.each do |issue|
        issue.push_to_project_burndown
      end
    end
  end
  

  module InstanceMethods
    def push_to_project_burndown
    end
    
    def create_project_burndown_story
      puts "create"
    end
    
    def update_project_burndown_story
      puts "update"
    end
    
    def destroy_project_burndown_story
      puts "destroy"
    end    
  end

end
