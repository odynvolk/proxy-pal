require 'core/synchronized_collection'

class PersistentCollection < SynchronizedCollection
  def initialize(options = {})
    super options[:input_file]

    @output_file = options[:output_file]

    @last_save = Time.now
  end

  def add(object)
    @mutex.synchronize do
      @collection.push object
    end

    now = Time.now
    if (@last_save + 60) < now
      save
      @last_save = now
    end
  end

  def save
    @mutex.synchronize do
      if @output_file.end_with? '.yml'
        FileUtil.write_yml @output_file, @collection
      else
        FileUtil.write_string @output_file, @collection.join("\n")
      end
    end
  end
end
