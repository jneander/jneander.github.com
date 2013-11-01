require 'fileutils'
require 'lib/amazon'
require 'lib/changeset'

OLD_BUILD = CONFIG[:old_build]
NEW_BUILD = CONFIG[:new_build]

def duplicate_directory(from, to)
  FileUtils.rm_r(to) if Dir.exists?(to)
  FileUtils.cp_r(from, to) if Dir.exists?(from)
end

def s3
  options = CONFIG[:amazon].merge(source_path: NEW_BUILD)
  Amazon::S3.new(options)
end

def changeset
  Changeset.new(old_path: OLD_BUILD, new_path: NEW_BUILD)
end

desc 'Deploy the site with the given name'
task :deploy do
  s3.deploy(changeset)
  duplicate_directory(NEW_BUILD, OLD_BUILD)
end
