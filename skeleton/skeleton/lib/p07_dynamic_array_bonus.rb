require 'byebug'

class StaticArray
  def initialize(capacity)
    @store = Array.new(capacity)
  end

  def [](i)
    validate!(i)
    @store[i]
  end

  def []=(i, val)
    validate!(i)
    @store[i] = val
  end

  def length
    @store.length
  end

  private

  def validate!(i)
    raise "Overflow error" unless i.between?(0, @store.length - 1)
  end
end

class DynamicArray
  include Enumerable
  attr_reader :count

  def initialize(capacity = 8)
    @store = StaticArray.new(capacity)
    @count = 0
  end

  def [](i)
    i = @count + i if i < 0
    @store[i]
  rescue
    nil
  end

  def []=(i, val)
    resize! until i < capacity
    i = @count + i if i < 0
    @store[i] = val
    @count = (i + 1) if i >= @count && val.nil? == false
  end

  def capacity
    @store.length
  end

  def include?(val)
    any? { |el| el == val }
  end

  def push(val)
    self[@count] = val
  end

  def unshift(val)
    resize! unless @count + 1 < capacity
    temp_store = StaticArray.new( capacity )
    (0...temp_store.length).each do |i|
      next if i == temp_store.length - 1
      temp_store[i + 1] = self[i]
    end
    temp_store[0] = val
    @store = temp_store
  end

  def pop
    return nil if @count == 0
    value = last
    self[@count - 1] = nil
    @count -= 1
    value
  end

  def shift
    return nil if @count == 0
    value = first
    each_with_index do |el, i|
      next if i == 0
      self[i - 1] = el
    end
    self[@count - 1] = nil
    @count -= 1
    value
  end

  def first
    self[0]
  end

  def last
    self[@count - 1]
  end

  def each(&prc)
    (0...@store.length).each do |i|
      prc.call(self[i])
    end
  end

  def to_s
    "[" + inject([]) { |acc, el| acc << el }.join(", ") + "]"
  end

  def ==(other)
    return false unless [Array, DynamicArray].include?(other.class)
    each_with_index do |el, i|
      return false unless other[i] == self[i]
    end
    true
  end

  alias_method :<<, :push
  [:length, :size].each { |method| alias_method method, :count }

  private

  def resize!
    new_array = StaticArray.new( capacity * 2)
    (0...@store.length).each do |i|
      new_array[i] = self[i]
    end
    @store = new_array
  end
end
