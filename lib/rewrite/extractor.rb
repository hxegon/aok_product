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

  def to_proc
    proc { |row| extract(row) }
  end

  def add(name:, &block)
    if [:name, :block].include? name.to_sym
      raise ArgumentError, "Name argument can't be 'name', :name, 'block', or :block"
    end

    @steps ||= {}
    @steps.merge name => block
  end

  def remove(name)
    @steps ||= {}
    @steps.delete(name)
  end

  def extract(row)
    @steps.map do |s|
      begin
        s[:block].call(row)
      rescue StandardError => e
        raise e, "Failed to execute extractor step #{name}"
      end
    end
  end
end
