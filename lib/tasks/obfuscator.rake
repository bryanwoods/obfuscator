namespace :obfuscator do
  desc "Scrub sensitive data for a given model's column"
  task :scrub, [:model] => :environment do |task, arguments|
    model   = arguments[:model]
    columns = ENV["COLUMNS"].split(",")

    Obfuscator.scrub! model do
      overwrite columns
    end
  end
end
