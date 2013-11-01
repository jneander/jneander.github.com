require 'jekyll'

def options
  @options ||= Jekyll.configuration(source: 'jekyll', destination: CONFIG[:new_build])
end

desc "Build the Jekyll site"
task :build do
  Jekyll::Commands::Build.process(options)
end

desc "Serve the Jekyll site"
task :serve do
  Jekyll::Commands::Serve.process(options)
end
