# INTERFACE: Intended to be called like a proc, or as a kiba transformer with #process
# EXPECTATIONS: Transformers should return the whole row, not just the part they changed
# @note There are no guarentees about what order the transformers will be run in.
class TransformerSet
  attr_reader :transformers

  def initialize
    @transformers = {}
  end

  # Reduces row with transformers
  def call(row)
    blocks.reduce(row) { |row_acc, t| t.call(row_acc) }
  end

  # @return a proc that calls self.call
  def to_proc
    proc { |row| call(row) }
  end

  # @alias for #call
  # @see for #call
  def process(row)
    call(row)
  end

  # Add a new transformer. Takes a symbol and a block
  # @params name Symbol
  # @note if you add a transformer with a name that already exists, the new one
    # replaces it
  def add(name, &block)
    @transformers[name.to_sym] = block
    self
  end

  # remove a transformer by name
  def remove(name)
    @transformers.delete(name.to_sym)
  end

  # return [Lambdas] returns a list of block type valuse. @transformers.values
  def blocks
    @transformers.values
  end

  def [](key)
    @transformers[key]
  end

  # alias for #transformers
  def to_hash
    @transformers
  end

  # Enable block construction syntax. returns self. Basically #tap.
  def generate
    yield self
    self
  end
end
