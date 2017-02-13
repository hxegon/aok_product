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

  # Converts a row # SHOULDN'T EXIST. Row field finding / extraction logic should be in extractor
  # THIS IS ALSO DESTRUCTIVE. NEEDS TO BE REWRITTEN
  def self.convert(raw_images_string)
    urls_to_image_hash(raw_images_string.split('&&'))
    # row.merge('images' => urls_to_image_hash(row['images'].split('&&')))
  end
end
