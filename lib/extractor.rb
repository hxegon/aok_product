# TODO: examples

# Manages and executes steps
class Extractor
  attr_reader :name

  # Takes a name, and a list of 'steps' (anything that responds to [:name] and
  # [:block], including an Extractor instance.)
  # @note Extractor steps don't have a guaranteed execution order, which
    # shouldn't matter if you wrote your steps as pure functions.
  def initialize(name, *steps)
    # GOALS:
    # Extensibility (user can add, remove extractor steps by name)
    # Steps only extract/transform parts they are concerned with
    # => they don't worry about mutating the result product to insert themselves back in
    @name = name
    steps.each { |s| add(name: s[:name], &s[:block]) }
  end

  def steps
    @steps
  end

  # access name or to_proc with hash like symbol syntax
  def [](key)
    case key.to_sym
    when :name
      name
    when :block
      to_proc
    else
      @steps[key]
    end
  end

  def to_proc # TODO: TEST IF NESTING EXTRACTORS WORK.
    # Because these are pure functions, might nested extractors work better by
    # just #to_hashing and merging with the steps?
    # This would cause any name conflicts to merge, which means the caller would
    # have to know of every name in the added extractor, so no.
    proc { |value| extract(value) }
  end

  # Add a step. Name collisions throw out the old one.
  # @return self
  def add(name:, &block)
    if [:name, :block].include? name.to_sym
      raise ArgumentError, "Name argument can't be 'name', :name, 'block', or :block"
    end

    @steps ||= {}
    @steps.merge! name => block
    self
  end

  def delete(name)
    @steps ||= {}
    unless (deleted_block = @steps.delete(name))
      nil
    else
      { name: name, block: deleted_block }
    end
  end

  def extract(value)
    @steps.values.map do |s|
      begin
        s.call(value)
      rescue StandardError => e
        raise e, "Failed to execute extractor step #{name}"
      end
    end
  end
end
