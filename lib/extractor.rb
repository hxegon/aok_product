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
    @steps = [
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

  # This will let you define new per instance step methods. Doesn't alter host
  # class.
  def define_step(name)
    # Can't use define_method directly, it's a private method.
    self.class.send(:define_method, name.to_sym) do |row|
      { name.to_s => (yield row) }
    end
  end

  def extract(row)
    @steps.map do |step_name|
      send(step_name, row)
    end
  end

  def to_proc
    proc { |value| extract(value) }
  end

  # NotImplementedError step stubs. If you call #extract on a subclass without
  # implementing all of the step methods, it will tell you which ones aren't
  # implemented.

  def taxons
    raise NotImplementedError
  end

  def images
    raise NotImplementedError
  end

  def properties
    raise NotImplementedError
  end

  def brand
    raise NotImplementedError
  end

  def price
    raise NotImplementedError
  end

  def cost
    raise NotImplementedError
  end

  def name
    raise NotImplementedError
  end

  def description
    raise NotImplementedError
  end

  def sku
    raise NotImplementedError
  end

  def upc
    raise NotImplementedError
  end

  def shipping_category
    raise NotImplementedError
  end

  def id
    raise NotImplementedError
  end

  def available_on
    raise NotImplementedError
  end
end
