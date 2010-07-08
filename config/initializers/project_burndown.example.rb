# save a copy of this file, properly configured, in your redmine's config/initializers directory and restart the app server
module ProjectBurndown
  class Config
    # grab the API Token from your profile page.
    API_TOKEN = "SOMETHING"
    SUBDOMAIN = "expectedbehavior"
    
    def self.api_token
      API_TOKEN
    end
    
    def self.subdomain
      SUBDOMAIN
    end
  end
end
