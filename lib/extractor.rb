# TODO: examples

# Manages and executes steps
class AbstractExtractor # Flog Score: 29
  def initialize(default_steps = Set.new)
    # GOALS:
    # Extensibility (user can add, remove extractor steps by name)
    # Steps only extract/transform parts they are concerned with
    # => they don't worry about mutating the result product to insert themselves back in
    # assert(default_steps.is_a?(Set))
    @step_methods = default_steps
  end

  # Takes a block that takes a row. Result of this is put into a hash. Key is
  # the name given to #define_step, and the value is the return val of the
  # block. Adds step to @step_methods. This will let you define new per
  # instance step methods. Doesn't alter host class.
  def define_step(name)
    # Can't use define_method directly, it's a private method.
    @step_methods << name.to_sym
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
  def method_missing(method_name, _)
    @step_methods&.include?(method_name) ? raise(NotImplementedError) : super
  end

  # prevents #method and #responds_to? from misbehaving.
  def respond_to_missing?(method_name, _)
    @step_methods&.include?(method_name) ? true : super
  end
end
