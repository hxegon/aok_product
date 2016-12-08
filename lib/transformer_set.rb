# INTERFACE: Intended to be called like a proc, or as a kiba transformer with #process
# EXPECTATIONS: Transformers should return the whole row, not just the part they changed
# @note There are no guarentees about what order the transformers will be run in.
class TransformerSet
  attr_reader :transformers

  def new
    @transformers = {}
  end

  # Reduces row with transformers
  def call(row)
    blocks.reduce(row) { |row_acc, t| t.call[row_acc] }
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
    @transformers.merge(name.to_sym => block)
  end

  # remove a transformer by name
  def remove(name)
    assert name.is_a? Symbol
    @transformers.delete(name)
  end

  # return [Lambdas] returns a list of block type valuse. @transformers.values
  def blocks
    @transformers.values
  end

  # alias for #transformers
  def to_hash
    @transformers
  end

  # Enable block construction syntax. returns self.
  def generate
    yield self
    self
  end
end
