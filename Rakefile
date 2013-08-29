#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

SIFDBilleder::Application.load_tasks

APP_ROOT="."
require 'jettywrapper'
require 'rsolr'

desc 'Start up jetty and run rspec and cucumber tests'
task :ci => ['jetty:unzip', 'jetty:config'] do
  puts 'running continuous integration'
  jetty_params = Jettywrapper.load_config
  error = Jettywrapper.wrap(jetty_params) do
    ping_solr #check solr is up before starting the tests
    Rake::Task['spec'].invoke
    Rake::Task['cucumber'].invoke
  end
  raise "test failures: #{error}" if error
end

#Because Jetty takes a long time to start Solr and Fedora we need to wait for it before starting the tests
#Following code attempts to connect to Solr and run a simple query, if the connection refused it catches
#this error and sleeps for 5 seconds before trying again until successful
def ping_solr
  begin
    solr = RSolr.connect :url => 'http://localhost:8983/solr'
    response = solr.get 'select', :params => {:q => '*:*'}
    puts 'Solr is up!'
    return
  rescue Errno::ECONNREFUSED
    puts 'Solr not up yet, sleeping for 10 seconds... zzz'
    sleep 10
    ping_solr
  end
end
