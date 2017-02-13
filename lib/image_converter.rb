# Reformat image fields from jensen csv hashes to strip flattening artifacts.
# @note No url validation
module ImageConverter
  # @param urls [String]
  # @return [Hash]
  # renamed from: urls_to_image_hash
  def self.convert(urls)
    urls.each_with_index.map do |url, ind|
      { 'title' => "Image #{ind + 1}", 'url' => url }
    end
  end
end
