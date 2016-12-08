require 'csv'
require_relative '../transformer_set'
require_relative '../index_groupable'
require_relative '../image_converter'

# Operates like a hash
module AOK
  module Products
    class Source
      attr_reader :products

      def self.from_file(filename, out)
        new(File.read(filename), out)
      end

      def initialize(text, processors = self.default_processors)
        @products = CSV.parse(input_file, headers: true, row_sep: :auto)
      end

      def each(&block)
        @products.each { |p| yield p }
      end
    end

    class Transform
      # Needs to be able to turn specific transformers on and off
      def new(processors = default_processors)
        @processors = default_processors
      end

      def default_processors
        # It's not AOK::Product::Source's responsibility to enable transformer extensibility. *POW* TransformerSet *BANG*
        TransformerSet.new.generate do |t|
          g.add(:taxons) do |row|
          end

          g.add(:images) do |row|
          end

          g.add(:attributes) do |row|
          end

          g.add(:brand) do |row|
          end

          g.add(:price) do |row|
          end

          g.add(:cost) do |row|
          end

          g.add(:name) do |row|
          end

          g.add(:description) do |row|
          end

          g.add(:sku) do |row|
          end

          g.add(:upc) do |row|
          end
        end
      end

      def process(row)
        @processor.call(row)
      end
    end
  end
end

