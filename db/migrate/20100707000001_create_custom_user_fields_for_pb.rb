class CreateCustomUserFieldsForPb < ActiveRecord::Migration
  def self.up
    UserCustomField.create!(:name => "Project Burndown User", :field_format => "int", :is_required => false, :is_for_all => false, :is_filter => false, :searchable => false, :default_value => nil, :editable => true)
  end

  def self.down
    pcf = ProjectCustomField.find_by_name("Project Burndown User")
    pcf.destroy
  end
end
