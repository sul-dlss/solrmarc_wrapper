require 'rspec/core/rake_task'

namespace :sm_wrap do

  desc "Run all specs, with jetty instance running"
  task :rspec => ['sm_wrap:jetty:config', 'sm_wrap:solrmarc:ant_dist_site'] do
    require 'jettywrapper'
    jetty_params = Jettywrapper.load_config.merge({
      :jetty_home => File.expand_path(File.dirname(__FILE__) + '../../../test-jetty'),
      :solr_home => File.expand_path(File.dirname(__FILE__) + '../../../test-jetty/solr'), 
      :jetty_port => 8983,
      :startup_wait => 25
    })
    error = Jettywrapper.wrap(jetty_params) do 
#      `sh ./scripts/curl_delete_solr.sh`
#      `sh ./scripts/curl_to_solr.sh`
      Rake::Task['sm_wrap:rspec_core'].invoke
    end
    raise "test failures: #{error}" if error
  end

  RSpec::Core::RakeTask.new(:rspec_core) do |spec|
    spec.rspec_opts = ["-c", "-f progress", "-r ./spec/spec_helper.rb"]
  end

end
