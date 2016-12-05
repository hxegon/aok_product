require 'csv'

# Operates like a hash
module AOK
  class Products
    attr_reader :products

    def self.from_file(filename, out)
      new(File.read(filename), out)
    end

    def initialize(text, out)
      @product = parse_to_hash(text)
    end

    def [](key)
      @products[key]
    end

    def to_hash
      @products
    end

    private

    def parse_to_hash(text)
      csv = CSV.parse(input_file, headers: true, row_sep: :auto)
      csv.map do |row| # 1 row = 1 product
        AOK::ProductProcess.parse(row)
      end
    end
  end
end

module AOK
  class ProductProcessor
    # Applies a list of processor lambdas to the input row, and merges the results
    # @see default_processors
    # @note This could be modified to take extra processors, or a custom list.
    # @note If processors produce output with conflicting keys, this will silently fail :(
    def self.process(row)
      # This could be parallelized if the need arises
      default_processors.map { |processor| processor.call(row) }
        .reduce({}, &:merge)
    end

    # An array of Lambdas that have a signature of Hash -> Hash
    # Should return just the processed pairs, not the whole input Hash
    def default_processors
      # This is a lazy way of being able to handle processors as a list of λs
      # TODO: Find a better way to handle default processors
      [
        # BOOKMARK: Fill in these processors
        # Taxons
        ->(row) {},
        # Images
        ->(row) {},
        # Attributes
        ->(row) {},
        # Brand
        ->(row) {},
        # Price
        ->(row) {},
        # Cost
        ->(row) {},
        # Name
        ->(row) {},
        # Description
        ->(row) {},
        # SKU
        ->(row) {},
        # UPC
        ->(row) {}
      ]
    end
  end
end
