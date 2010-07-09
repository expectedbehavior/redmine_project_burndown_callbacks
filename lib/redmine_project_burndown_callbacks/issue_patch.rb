module RedmineProjectBurndownCallbacks

  # patch in some after_save filter action
  module IssuePatch
    PB_FINISHED  = "finished"
    PB_STARTED   = "started"
    PB_UNSTARTED = "unstarted"

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
    def project_burndown_project_id
      pcf_id = ProjectCustomField.find_by_name("Project Burndown Project", :select => "id").id
      project_burndown_project_id = CustomValue.find(:first, :conditions => { :customized_type => "Project", :custom_field_id => pcf_id, :customized_id => 1}).value.to_i
      project_burndown_project_id <= 0 ? nil : project_burndown_project_id
    end

    def push_to_project_burndown(status = Issue::PB_UNSTARTED)
      pb_project_id = self.project_burndown_project_id
      if pb_project_id
        remote_story = ProjectBurndown::Api::V1::RemoteStory.new
        remote_story.attributes = { "current_state" => self.project_burndown_status, "id" => self.id, "name" => self.subject }
        remote_story.prefix_options = { :project_id => pb_project_id, :service_type_id => "redmine" }
        remote_story.save
      end
    end

    def create_project_burndown_story
      self.push_to_project_burndown
    end

    def update_project_burndown_story
      self.push_to_project_burndown(self.project_burndown_status)
    end

    def destroy_project_burndown_story
      pb_project_id = self.project_burndown_project_id
      if pb_project_id
        remote_story = ProjectBurndown::Api::V1::RemoteStory.new
        remote_story.attributes = { "id" => self.id }
        remote_story.prefix_options = { :project_id => pb_project_id, :service_type_id => "redmine" }
        remote_story.destroy
      end
    end

    # this will have to be configured here for the time being
    # PB might at some point have a mapping feature
    def project_burndown_status
      status = self.reload.status.reload.to_s
      return self.class::PB_FINISHED if ["Closed"].include?(status)
      return self.class::PB_STARTED if ["In Progress", "Resolved", "Feedback", "Rejected"].include?(status)
      self.class::PB_UNSTARTED
    end
  end

end
