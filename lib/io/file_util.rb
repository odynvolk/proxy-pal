require 'yaml'
require 'fileutils'

module FileUtil
  extend self

  def read_string(filename)
    if File.exist?(filename)
      File.open(filename, 'rb') { |file| file.read }
    else
      ''
    end
  end

  def write_string(filename, str)
    File.open(filename, 'w') {|f| f.write(str) }
  end

  def read_yml(filename)
    if File.exist?(filename)
      YAML.load(File.open(filename))
    else
      {}
    end
  end

  def write_yml(filename, items)
    File.open(filename, 'w') { |out| out << items.to_yaml }
  end
end
