require 'csv'
require_relative 'transformer_set'
require_relative 'image_converter'

# Operates like a hash
module AOK
  module Products
    class Source
      attr_reader :products, :transformers

      # It's not AOK::Product::Source's responsibility to enable transformer extensibility. *POW* TransformerSet *BANG*
      DEFAULT_TRANSFORMER = TransformerSet.new.generate do |t|
        t.add(:taxons) do |row|
        end

        t.add(:images) do |row|
          ImageConverter.convert(row)
        end

        t.add(:attributes) do |row|
          row.tap do |r| # wrap []= so we return the entire hash
            r['properties'] =
              r.select { |(header, _)| header[0] == '@' } # find cells with attribute headers
              .map { |k, v| [k.remove('@'), v] }          # remove attr identifier char: '@'
              .map { |hash_arr| Hash[hash_arr] }          # convert Hash map output (Array of Arrays) to Array of Hashes
              .reduce(&:merge)                            # merge Array of Hashes into single hash
          end
        end

        t.add(:brand) do |row|
        end

        t.add(:price) do |row|
        end

        t.add(:cost) do |row|
        end

        t.add(:name) do |row|
        end

        t.add(:description) do |row|
        end

        t.add(:sku) do |row|
        end

        t.add(:upc) do |row|
        end
      end
    end

    # I don't think this default_transformer thing is working rn :(
    def self.from_file(transformer=default_transformer, filename)
      new(transformer, File.read(filename))
    end

    def initialize(transformer=default_transformer, text)
      @products = CSV.parse(text, headers: true, row_sep: :auto)
      @transformer = transformer
    end

    def each
      @products.each { |p| yield p }
    end
  end
end
