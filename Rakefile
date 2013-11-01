$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__))
CONFIG = YAML.load_file("config.yml")

Dir.glob('tasks/*.rake').each {|r| load r}

task default: [:spec]

desc "Run specs, build site, deploy"
task release: [:spec, :build, :deploy]
