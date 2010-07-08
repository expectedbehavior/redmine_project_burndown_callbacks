module ProjectBurndown
  class Api::V1::Project < ActiveResource::Base
    #self.site = "http://#{ProjectBurndown::Config.subdomain}.projectburndown.com"
    self.site = "http://#{ProjectBurndown::Config.subdomain}.pb.local:10000/api/v1"
    self.element_name = "project"
    self.timeout = 15
  end
end
