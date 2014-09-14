require 'rubygems'
require 'gooddata'

AUTH_TOKEN = 'ONBDIS852d718ca'

# GoodData.logging_on

GoodData.with_connection('quincy@courseforward.com', 'burnrate') do |c|
  blueprint = GoodData::Model::ProjectBlueprint.build("burnrate") do |p|
    p.add_date_dimension('date')

    p.add_dataset('quotes') do |d|
      d.add_date('date', :dataset => "date")
      d.add_fact('open', :gd_data_type => "DECIMAL(12,2)")
      d.add_fact('high', :gd_data_type => "DECIMAL(12,2)")
      d.add_fact('low', :gd_data_type => "DECIMAL(12,2)")
      d.add_fact('close', :gd_data_type => "DECIMAL(12,2)")
      d.add_fact('volume', :gd_data_type => "DECIMAL(12,2)")
      d.add_fact('oi', :gd_data_type => "DECIMAL(12,2)")
    end
  end

  project = GoodData::Project.create_from_blueprint(blueprint, :auth_token => AUTH_TOKEN)
  puts "Created project #{project.pid}"

  GoodData::with_project(project.pid) do |p|
    # Load data
    GoodData::Model.upload_data('~web/burnrate/app/assets/data/ndx.csv', blueprint, 'quotes')
    
    # create  metric

# create a metric
    metric = p.fact('fact.quotes.volume').create_metric
    metric.save
    
    report = p.create_report(title: 'Awesome_report', top: [metric], left: ['date.date.mmddyyyy'])
    report.save

  end
end