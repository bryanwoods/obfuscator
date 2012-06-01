namespace :obfuscator do
  desc "Scrub sensitive data in provided model's columns"

  task :scrub, [:model, :columns] => :environment do |task, arguments|
    model   = arguments[:model]
    columns = arguments[:columns]

    obfuscator = Obfuscator::Generic.new

    obfuscator.scrub!(model, columns)
  end
end
