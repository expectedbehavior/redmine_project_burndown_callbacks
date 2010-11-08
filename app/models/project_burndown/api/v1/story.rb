module ProjectBurndown
  class Api::V1::Story < ActiveResource::Base
    self.site = "http://#{ProjectBurndown::Config.subdomain}.projectburndown.com"
    self.prefix = "/api/v1"
    self.element_name = "story"
    self.timeout = 15
  end
end
