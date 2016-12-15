# refines a method, Enumerable#map_with_index
# @see Enumerable#each_with_index
module MapWithIndex
  refine Array do # Would refine Enumerable, but you can only refine classes, not modules.
    def map_with_index
      index = 0 # acts as an index, works like a counter
      map do |element|
        (yield element, index).tap { |_| index += 1 }
      end
    end
  end
end

# Reformat image fields from jensen csv hashes to strip flattening artifacts.
# @see .call
# @note nothing in this class does URL validation.
class ImageConverter
  using MapWithIndex

  # @param urls [String]
  # @return [Hash]
  def self.urls_to_image_hash(urls)
    urls.map_with_index do |e, ind|
      { 'title' => "Image #{ind + 1}", 'url' => e }
    end
  end

  # alias to .convert
  # @see convert
  def self.call(row)
    convert(row)
  end

  def self.to_proc
    proc { |row| self.class.convert(row) }
  end

  # Converts a row
  def self.convert(row)
    row.merge('images' => urls_to_image_hash(row['images'].split('&&')))
  end
end
