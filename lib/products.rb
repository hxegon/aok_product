# require 'kiba' # Either do or don't use kiba bruh
require 'csv'

# Operates like a hash
module AOK
  module Products
    class Source
      attr_reader :products

      def self.from_file(filename, out)
        new(File.read(filename), out)
      end

      def initialize(text, processors = self.default_processors)
        @products = CSV.parse(input_file, headers: true, row_sep: :auto)
      end

      def each(&block)
        @products.each { |p| yield p }
      end
    end

    class Transform
      # Needs to be able to turn specific transformers on and off
      def new(processors = default_processors)
        @processors = default_processors
      end

      def default_processors
        # It's not AOK::Product::Source's responsibility to enable transformer extensibility. *POW* TransformerSet *BANG*
        TransformerSet.new.generate do |t|
          g.add(:taxons) do |row|
          end

          g.add(:images) do |row|
          end

          g.add(:attributes) do |row|
          end

          g.add(:brand) do |row|
          end

          g.add(:price) do |row|
          end

          g.add(:cost) do |row|
          end

          g.add(:name) do |row|
          end

          g.add(:description) do |row|
          end

          g.add(:sku) do |row|
          end

          g.add(:upc) do |row|
          end
        end
      end

      def process(row)
        @processor.call(row)
      end
    end
  end
end

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
    proc { |row| self.call(row) }
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
    assert name.is_a? Symbol
    @transformers.merge name: block
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
  def generate(&block)
    yield self
    self
  end
end
