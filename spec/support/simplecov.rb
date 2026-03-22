# frozen_string_literal: true

require 'simplecov'

SimpleCov.formatter = SimpleCov::Formatter::HTMLFormatter
SimpleCov.start 'rails' do
  enable_coverage_for_eval
  add_filter(%r{^/spec/})
  add_filter('/app/channels/')
  add_filter('/app/jobs/')
  add_filter('/app/mailers/')
  add_filter('application_record.rb')
  add_filter('application_job.rb')
  add_filter('application_mailer.rb')
  add_filter('application_cable/')
  enable_coverage(:branch)
end
