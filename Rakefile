require 'bundler/gem_tasks'

# Don't push the gem to rubygems.org
ENV['gem_push'] = 'false'

Rake::Task['release'].enhance do
  spec = Gem::Specification.load(Dir.glob('*.gemspec').first)
  sh "gem inabox pkg/#{spec.name}-#{spec.version}.gem"
end

desc "Run a pry session with the gem's code loaded"
task :console do
  sh 'pry -I lib -r ncpdp_epa'
end
