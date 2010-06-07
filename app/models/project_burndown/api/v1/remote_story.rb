module ProjectBurndown
  class Api::V1::RemoteStory < ActiveResource::Base
    API_TOKEN = "eSqfNV08o-FDkgCbPWV4"
    
    #self.site = "http://expectedbehavior.projectburndown.com"
    self.site = "http://expectedbehavior.pb.local:10000/api/v1/projects/:project_id/service_types/:service_type_id"
    self.element_name = "remote_story"

    def collection_path(prefix_options = {}, query_options = nil)
      prefix_options = prefix_options.merge!(@prefix_options)
      "/api/v1/projects/#{prefix_options[:project_id]}/service_types/#{prefix_options[:service_type_id]}/remote_stories.xml?user_credentials=#{API_TOKEN}"
    end
    
    def element_path(id, prefix_options = {}, query_options = nil)
      prefix_options = prefix_options.merge!(@prefix_options)
      "/api/v1/projects/#{prefix_options[:project_id]}/service_types/#{prefix_options[:service_type_id]}/remote_stories/#{id}.xml?user_credentials=#{API_TOKEN}"
    end
  end
end
