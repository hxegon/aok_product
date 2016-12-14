class Assembler
  attr_accessor :source, :extractor

  def initialize(source, extractor)
    @source    = source
    @extractor = extractor
    # @merge     = block || proc { |bits| bits.reduce(&:merge) }
  end

  def products
    @source.map { |raw_product| @extractor.extract(raw_product) }
           .reduce(&:merge)
  end
end
