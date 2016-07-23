require_relative 'p05_hash_map'
require_relative 'p04_linked_list'

class LRUCache
  attr_reader :count
  def initialize(max, prc)
    @map = HashMap.new
    @store = LinkedList.new
    @max = max
    @prc = prc
  end

  def count
    @map.count
  end

  def get(key)
    if @map.include?(key)
      update_link!(@map[key])
      @map[key] = @store.last
    else
      eject! if count == @max
      @map[key] = calc!(key)
    end
    @store.last.val
  end

  def to_s
    "Map: " + @map.to_s + "\n" + "Store: " + @store.to_s
  end

  private

  def calc!(key)
    # suggested helper method; insert an (un-cached) key
    value = @prc.call(key)
    @store.insert(key, value)
    @store.last
  end

  def update_link!(link)
    # suggested helper method; move a link to the end of the list
    value = link.val
    link.prev.next = link.next
    link.next.prev = link.prev
    @store.insert(link.key, value)
  end

  def eject!
    del_key = @store.first.key
    @store.remove(@store.first)
    @map.delete(del_key)
  end
end
