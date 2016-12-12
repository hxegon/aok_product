# TODO: examples

class Extractor
  attr_reader :name

  # Needs a name, and a list of 'steps' is anything that responds to [:name]
  # and [:block]
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

  # access name or to_proc with hash like symbol syntax
  def [](name_or_block)
    case name_or_block.to_sym
    when :name
      name
    when :block
      to_proc
    else
      nil
    end
  end

  def to_proc
    proc { |row| extract(row) }
  end

  def add(name:, &block)
    @steps ||= {}
    @steps.merge name => block
  end

  def remove(name)
    @steps ||= {}
    @steps.delete(name)
  end

  def extract(row)
    @steps.map { |s| s[:block].call(row) }
  end
end
