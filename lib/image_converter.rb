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
# @note No url validation
module ImageConverter
  using MapWithIndex

  # @param urls [String]
  # @return [Hash]
  # renamed from: urls_to_image_hash
  def self.convert(urls)
    urls.map_with_index do |url, ind|
      { 'title' => "Image #{ind + 1}", 'url' => url }
    end
  end
end
