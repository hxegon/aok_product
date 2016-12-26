# TODO: examples
# TODO: REWRITE ADD to define_method instead of storing a lambda hash.
#   - refactor other methods to use #send instead of #call
#   - Should extractor be a super class? Yes

# Manages and executes steps
class Extractor # Flog Score: 29
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
      :shipping_category
    ]
  end

  def to_proc
    proc { |value| extract(value) }
  end

  def extract(value)
    @steps.map do |step_name|
      send(step_name)
    end
  end

  def taxons
    raise NotImplementedError
  end

  def images
    raise NotImplement
  end

  def properties
    raise NotImplement
  end

  def brand
    raise NotImplement
  end

  def price
    raise NotImplement
  end

  def cost
    raise NotImplement
  end

  def name
    raise NotImplement
  end

  def description
    raise NotImplement
  end

  def sku
    raise NotImplement
  end

  def upc
    raise NotImplement
  end

  def shipping_category
    raise NotImplementedError
  end
end
