# Defines a sort of extractor dsl. See add_step(s), define_step, extract.
# Intended for use as a superclass. Not the sort of thing I'd put in a module.
# For an example of usage, look at aok_extractor.
class AbstractExtractor
  class << self
    # the classes set of steps
    def step_methods
      @step_methods ||= Set.new
    end

    # add multiple steps to the class's set of steps
    def add_steps(steps)
      step_methods.merge(steps.map(&:to_sym))
    end

    # add a step to the class's set of steps
    def add_step(step)
      step_methods << step.to_sym
    end

    # Takes a block that takes a row. defines a new instance method which
    # returns the result of the block in a hash with name parameter as the key.
    # Adds step to step_methods.
    def define_step(name)
      add_step name.to_sym
      send(:define_method, name.to_sym) { |row| { name.to_s => (yield row) } }
    end
  end

  # The object's class's set of steps
  def step_methods
    self.class.step_methods
  end

  # Call step methods, combines and return results.
  def extract(row)
    step_methods.map do |step_name|
      send(step_name, row)
    end.reduce(&:merge)
  end

  def to_proc
    proc { |value| extract(value) }
  end

  # Raise NotImplementedError if a step method isn't defined, otherwise super
  def method_missing(method_name, _)
    step_methods&.include?(method_name) ? raise(NotImplementedError) : super
  end

  # prevents #method and #responds_to? from misbehaving.
  def respond_to_missing?(method_name, _)
    step_methods&.include?(method_name) ? true : super
  end
end
