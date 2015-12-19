require 'thread'

class SynchronizedCollection
  def initialize(file = nil)
    initialize_collection file

    @mutex = Mutex.new
    @index = 0
  end

  def add_all(objects)
    @mutex.synchronize do
      @collection += objects
    end
  end

  def clear
    @mutex.synchronize do
      @collection = []
    end
  end

  def empty?
    @collection.empty?
  end

  def include?(object)
    @collection.include? object
  end

  def next
    @mutex.synchronize do
      obj = @collection[@index]
      if @index + 1 < @collection.size
        @index += 1
      else
        @index == 0
      end

      obj
    end
  end

  def more?
    (@index < @collection.count - 1) ? true : false
  end

  def uniq!
    @mutex.synchronize do
      @collection.uniq!
    end
  end

  def pop_first
    @mutex.synchronize do
      @collection.delete_at(0)
    end
  end

  def sample
    @collection.sample
  end

  def shuffle!
    @mutex.synchronize do
      @collection.shuffle!
    end
  end

  def size
    @collection.size
  end

  private

  def initialize_collection(file)
    unless file.nil?
      if file.end_with? '.yml'
        @collection = FileUtil.read_yml file
      else
        @collection = []
        FileUtil.read_string(file).each_line {|line| @collection << line.chomp}
      end
    end
    @collection = [] if @collection.nil?
  end
end
