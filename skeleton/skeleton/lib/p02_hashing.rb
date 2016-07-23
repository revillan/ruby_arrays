class Fixnum
  # Fixnum#hash already implemented for you
end

class Array
  def hash
    hashed = self.map.with_index {|el, i| el.hash + i.hash }
    hashed.inject(0) {|a, b| a ^ b }
  end
end

class String
  def hash
    self.chars.map(&:ord).hash ^ 5.hash
  end
end

class Hash
  # This returns 0 because rspec will break if it returns nil
  # Make sure to implement an actual Hash#hash method
  def hash
    self.to_a.sort.hash ^ 27.hash
  end
end
