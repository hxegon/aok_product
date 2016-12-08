# Reformat image fields from jensen csv hashes to strip flattening artifacts.
# @see .call
class ImageConverter
  include IndexGroupable

  # Makes new instance, calls #convert.
  # @example
  #   image = { 'image_reference_1' => 'http://www.dot.com',
  #              'image_name_1'      => 'homepage' }
  #   ImageConverter.call(image)
  #   # => image = {
  #     'url' => 'http://www.dot.com',
  #     'title' => 'homepage'
  #   }
  # @param image [Hash]
  # @return [Hash]
  def self.call(image)
    new(image).send(:convert)
  end

  # Finds hash fields with a key starting with 'images_'
  # @param hash [Hash]
  # @return [Hash]
  def self.find_images(hash)
    Hash[hash.select { |(k, _)| k =~ /\Aimage_.+/ }]
  end

  def self.convert(row)
    find_images(row).keys.each do |old_image_field|
      row.delete(old_image_field)
    end
    row['images'] = call(images)
  end

  private

  def initialize(image_hash)
    @images = image_hash
  end

  def convert
    rename_keys!
    filter_blanks!
    @images
  end

  def filter_blanks!
    is_blank = ->(o) { o.nil? || o.empty? }
    @images.reject! { |img| is_blank[img['title']] || is_blank[img['url']] }
  end

  def rename_keys!
    @images = group_by_index(@images)
    @images.map! { |g| Hash[g.map { |k, v| [rename_key(k), v] }] }
  end

  def rename_key(image_key)
    lookup = { 'reference' => 'url', 'name' => 'title' }
    lookup[image_key.match(/image_(\w+)_\d+/).captures[0]]
  end
end
