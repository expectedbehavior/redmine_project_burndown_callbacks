module ProjectBurndown
  class Api::V1::Project < ActiveResource::Base
    #self.site = "http://expectedbehavior.projectburndown.com"
    self.site = "http://expectedbehavior.pb.local:10000/api/v1"
    self.element_name = "project"
    self.timeout = 15
  end
end
