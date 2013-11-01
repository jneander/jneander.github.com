require 'fileutils'
require 'webmock/rspec'

module FileHelpers
  TMP_PATH = "_tmp/"

  def ensure_path!(path)
    FileUtils.mkdir_p(path) unless File.directory?(path)
  end

  def create_file!(name, content = "")
    ensure_path!(File.dirname(tmp(name)))
    File.open(tmp(name), 'w') {|f| f.write(content)}
  end

  def tmp(name)
    TMP_PATH + name
  end

  def remove_tmp!
    FileUtils.rm_r(TMP_PATH) if Dir.exists?(TMP_PATH)
  end
end

RSpec.configure do |config|
  include FileHelpers

  config.after(:each) do
    remove_tmp!
  end
end
