require_relative 'p02_hashing'

class HashSet
  attr_reader :count

  def initialize(num_buckets = 8)
    @store = Array.new(num_buckets) { Array.new }
    @count = 0
  end

  def insert(key)
    break if include?(key)
    @count += 1
    resize! if @count == @store.length
    self[key] << key
  end

  def include?(key)
    self[key].include?(key)
  end

  def remove(key)
    self[key].delete(key)
    @count -= 1
  end

  private

  def [](key)
    @store[key.hash % num_buckets]
  end

  def num_buckets
    @store.length
  end

  def resize!
    @store += Array.new(count) { [] }
    temp_store = @store.flatten
    @store.map! { [] }
    @count = 1
    temp_store.each do |el|
      insert(el)
    end
  end
end
