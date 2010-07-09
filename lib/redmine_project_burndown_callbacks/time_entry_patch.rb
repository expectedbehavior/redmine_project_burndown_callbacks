module RedmineProjectBurndownCallbacks
  module TimeEntryPatch
    def self.included(base)
      base.extend(TimeEntryClassMethods)
      
      base.send(:include, TimeEntryInstanceMethods)
      
      base.class_eval do
        unloadable # Send unloadable so it will not be unloaded in development
        after_create  :create_project_burndown_time_entry
        after_update  :update_project_burndown_time_entry
        after_destroy :destroy_project_burndown_time_entry
      end
    end
  end
  
  module TimeEntryClassMethods
    def sync_with_project_burndown
      TimeEntry.all.each do |time_entry|
        time_entry.push_to_project_burndown
      end
    end
  end
  
  module TimeEntryInstanceMethods
    def project_burndown_project_id
      pcf_id = ProjectCustomField.find_by_name("Project Burndown Project", :select => "id").id
      pb_project_id = CustomValue.find(:first, :conditions => { :customized_type => "Project", :custom_field_id => pcf_id, :customized_id => self.project_id})
      return nil if pb_project_id.blank?
      pb_project_id.value.to_i
    end
    
    def project_burndown_user_id
      pcf_id = UserCustomField.find_by_name("Project Burndown User", :select => "id").id
      pb_user_id = CustomValue.find(:first, :conditions => { :customized_type => "Principal", :custom_field_id => pcf_id, :customized_id => self.user_id})
      return nil if pb_user_id.blank?
      pb_user_id.value.to_i
    end

    def push_to_project_burndown
      pb_project_id = self.project_burndown_project_id
      pb_user_id = self.project_burndown_user_id
      if pb_project_id && pb_user_id
        remote_time_entry = ProjectBurndown::Api::V1::RemoteTimeEntry.new
        remote_time_entry.attributes = { "id" => self.id, "notes" => self.comments.blank? ? self.issue.subject : self.comments, "hours" => self.hours, "user_id" => pb_user_id }
        remote_time_entry.prefix_options = { :project_id => pb_project_id, :service_type_id => "redmine" }
        remote_time_entry.save
      end
    end
    
    def create_project_burndown_time_entry
      self.push_to_project_burndown
    end

    def update_project_burndown_time_entry
      self.push_to_project_burndown
    end

    def destroy_project_burndown_time_entry
      pb_project_id = self.project_burndown_project_id
      pb_user_id = self.project_burndown_user_id
      if pb_project_id && pb_user_id
        remote_time_entry = ProjectBurndown::Api::V1::RemoteTimeEntry.new
        remote_time_entry.attributes = { "id" => self.id }
        remote_time_entry.prefix_options = { :project_id => pb_project_id, :service_type_id => "redmine" }
        remote_time_entry.destroy rescue nil
      end
    end
  end
  
end
