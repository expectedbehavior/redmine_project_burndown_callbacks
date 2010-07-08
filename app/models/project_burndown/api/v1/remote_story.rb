module ProjectBurndown
  class Api::V1::RemoteStory < ActiveResource::Base    
    #self.site = "http://#{ProjectBurndown::Config.subdomain}.projectburndown.com"
    self.site = "http://#{ProjectBurndown::Config.subdomain}.pb.local:10000/api/v1/projects/:project_id/service_types/:service_type_id"
    self.element_name = "remote_story"

    def collection_path(prefix_options = {}, query_options = nil)
      prefix_options = prefix_options.merge!(@prefix_options)
      "/api/v1/projects/#{prefix_options[:project_id]}/service_types/#{prefix_options[:service_type_id]}/remote_stories.xml?user_credentials=#{ProjectBurndown::Config.api_token}"
    end
    
    def element_path(prefix_options = {}, query_options = nil)
      self.attributes["remote_story_id"] ||= self.id
      prefix_options = prefix_options.merge!(@prefix_options)
      "/api/v1/projects/#{prefix_options[:project_id]}/service_types/#{prefix_options[:service_type_id]}/remote_stories/#{self.attributes["remote_story_id"]}.xml?user_credentials=#{ProjectBurndown::Config.api_token}"
    end
  end
end
