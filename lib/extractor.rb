# TODO: examples
# TODO: REWRITE ADD to define_method instead of storing a lambda hash.
#   - refactor other methods to use #send instead of #call
#   - Should extractor be a super class? Yes


# Manages and executes steps
class AbstractExtractor # Flog Score: 29
  def initialize
    # GOALS:
    # Extensibility (user can add, remove extractor steps by name)
    # Steps only extract/transform parts they are concerned with
    # => they don't worry about mutating the result product to insert themselves back in
    @step_methods = Set[ # TODO: should this be a Set? Extracted to constant? Frozen?
      :taxons,
      :images,
      :properties,
      :brand,
      :price,
      :cost,
      :name,
      :description,
      :sku,
      :upc,
      :shipping_category,
      :id,
      :available_on
    ]
  end

  # Takes a block that takes a row. Result of this is put into a hash. Key is the
  # name given to #define_step, and the value is the return val of the block.
  # This will let you define new per instance step methods. Doesn't alter host
  # class.
  def define_step(name)
    # Can't use define_method directly, it's a private method.
    # TODO add a given step to @step_methods
    self.class.send(:define_method, name.to_sym) do |row|
      { name.to_s => (yield row) }
    end
  end

  def extract(row)
    @step_methods.map do |step_name|
      send(step_name, row)
    end
  end

  def to_proc
    proc { |value| extract(value) }
  end

  # Raise NotImplementedError if a step method isn't defined
  def method_missing(method_name)
    @step_methods.include?(method_name) ? raise(NotImplementedError) : super
  end

  # prevents #method and #responds_to? from misbehaving.
  def respond_to_missing?(method_name, _)
    @step_methods.include?(method_name) ? true : super
  end
end
