namespace :test do
  task :test => :environment do  | task |
    desc "test task"

    p Time.now.to_s + 'task test start'
    p Time.now.to_s + 'task test end'
  end
end