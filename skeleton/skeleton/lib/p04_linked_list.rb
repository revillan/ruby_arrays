class Link
  attr_accessor :key, :val, :next, :prev

  def initialize(key = nil, val = nil)
    @key = key
    @val = val
    @next = nil
    @prev = nil
  end

  def to_s
    "#{@key}: #{@val}"
  end
end

class LinkedList
  include Enumerable

  def initialize
    @head = Link.new
    @tail = Link.new
    set_sentinel_pntrs
  end

  def set_sentinel_pntrs
    @head.next = @tail
    @tail.prev = @head
  end

  def [](i)
    each_with_index { |link, j| return link if i == j }
    nil
  end

  def first
    @head.next unless empty?
  end

  def last
    @tail.prev unless empty?
  end

  def empty?
    @head.next == @tail
  end

  def get(key)
    each { |link| return link.val if link.key == key}
    nil
  end

  def include?(key)
    any? { |link| link.key == key }
  end

  def insert(key, val)
    if include?(key)
      each { |link| link.val = val if link.key == key }
    else
      new_link = Link.new(key, val)
      @tail.prev.next = new_link
      new_link.prev = @tail.prev
      @tail.prev = new_link
      new_link.next = @tail
    end
  end

  def remove(key)
    if include?(key)
      link = select { |link| link.key == key }.first
      link.next.prev = link.prev
      link.prev.next = link.next
    end
  end

  def each(&prc)
    current = @head.next
    until current == @tail
      prc.call(current)
      current = current.next
    end
    self
  end

  def to_s
    inject([]) { |acc, link| acc << "[#{link.key}, #{link.val}]" }.join(", ")
  end
end
