require 'fileutils'

class Changeset
  def initialize(options)
    @old_path = options[:old_path]
    @new_path = options[:new_path]
    validate_options!
    initialize!
  end

  def updated
    added + changed
  end

  def removed
    old_files - new_files
  end

  private

  def initialize!
    updated and removed
  end

  def added
    @added ||= new_files - old_files
  end

  def changed
    @changed ||= (old_files & new_files).select {|file|
      !FileUtils.identical?("#{@old_path}/#{file}", "#{@new_path}/#{file}")
    }
  end

  def validate_options!
    unless FileTest.exists?(@old_path) || FileTest.exists?(@new_path)
      raise ArgumentError, "You must specify valid paths to compare"
    end
  end

  def old_files
    @old_files ||= remove_root(@old_path, list_files(@old_path))
  end

  def new_files
    @new_files ||= remove_root(@new_path, list_files(@new_path))
  end

  def list_files(path)
    return [] unless File.directory?(path)
    entries = Dir.entries(path) - [".", ".."]
    entries.reduce([]) do |list, entry|
      candidate = [path, entry].join("/")
      list << candidate unless File.directory?(candidate)
      list += list_files(candidate)
    end
  end

  def remove_root(root, paths)
    paths.map {|path| path.sub(root + "/", "")}
  end
end
