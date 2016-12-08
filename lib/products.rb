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

      def initialize(text)
        @products = CSV.parse(text, headers: true, row_sep: :auto)
      end

      def each
        @products.each { |p| yield p }
      end
    end

    class Transform
      # Needs to be able to turn specific transformers on and off
      def new(processors = default_processors)
        @processors = processors
      end

      def default_processors
        # It's not AOK::Product::Source's responsibility to enable transformer extensibility. *POW* TransformerSet *BANG*
        TransformerSet.new.generate do |t|
          t.add(:taxons) do |row|
          end

          t.add(:images) do |row|
            # ImageConverter.convert(row)
            # Should this be completely encapsulated by ImageConverter?
            images = ImageConverter.find_images(row)
            images.keys.each do |old_image_field|
              row.delete(old_image_field)
            end
            row['images'] = ImageConverter.call(images)
          end

          t.add(:attributes) do |row|
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

      def process(row)
        @processor.call(row)
      end
    end
  end
end
