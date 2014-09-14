require 'rubygems'
require 'gooddata'

AUTH_TOKEN = 'ONBDIS852d718ca'

GoodData.logging_on

GoodData.with_connection('quincy@courseforward.com', 'burnrate') do |c|
  blueprint = GoodData::Model::ProjectBlueprint.build("burnrate") do |p|
    p.add_dataset('activities') do |d|
      d.add_attribute('time')
      d.add_fact('velocity')
    end
  end

  project = GoodData::Project.create_from_blueprint(blueprint, :auth_token => AUTH_TOKEN)
  puts "Created project #{project.pid}"

  GoodData::with_project(project.pid) do |p|
    # Load data
    GoodData::Model.upload_data('/Users/michaelq/web/burnrate/app/assets/data/burnrate.csv', blueprint, 'activities')
    
    # create  metric

# create a metric
    metric = p.fact('fact.activities.velocity').create_metric
    metric.save
    
    report = p.create_report(title: 'Activities', top: [metric], left: ['attr.activities.time'])
    report.save

  end
end