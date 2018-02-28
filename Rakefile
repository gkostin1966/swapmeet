# frozen_string_literal: true

# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'

Rails.application.load_tasks

# Get rid of the default task (was spec)
task default: []
Rake::Task[:default].clear

Rake::Task["db:migrate"].enhance do
  Rake::Task["checkpoint:migrate"].invoke
end

task default: :ci
