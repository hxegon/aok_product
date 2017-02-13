require_relative 'image_converter'
require_relative 'extractor'
require_relative 'string_normalize'

module HashGrepFirst
  refine Hash do
    def grep_first(pattern)
      self[keys.grep(pattern).first]
    end
  end
end

class AOKExtractor < Extractor
  using HashGrepFirst

  def taxons(row)
    { 'taxons' =>
      row.keys.grep(/taxon/i).map do |k|
        row[k].split('&&')                                 # Split taxon strings
          .map { |taxon_string| taxon_string.split('//') } # Split to taxon chain
      end.flatten(1)                                       # turn [ [ [taxon chain] ] ] to [ [taxon chain] ]
    }
  end

  def images(row)
    raw_images = row.grep_first(/images/i).split('&&')
    images     = ImageConverter.convert(raw_images || 'https://i.imgur.com/BAbXpMz.jpg')
    images.each do |image|
      image.each do |(k, v)|
        image[k] = URI.decode(v).normalize(/.ashx\s*\z/i, '.jpg') if k == 'url'
      end
    end
    { 'images' => images } # TMP: Give cheeky 404 image if raw_images is nil
  end

  def properties(row)
    { 'properties' =>
      row.select { |(header, _)| header[0] == '@' } # find cells with attribute headers
        .reject { |_, val| val =~ /\A\s*x?\s*\z/i } # check is only x and or whitespace
        .map { |(k, v)| [k.sub(/@/, ''), v] }       # remove attr identifier char: '@'
        .map { |hash_arr| Hash[*hash_arr] }         # convert Hash map output (Array of Arrays) to Array of Hashes
        .reduce(&:merge) || {}                      # merge Array of Hashes into single hash
    }
  end

  def brand(row)
    { 'brand' => row.grep_first(/brand/i) }
  end

  def price(row)
    { 'price' => Float(row.grep_first(/price/i)) }
  end

  def cost(row)
    { 'cost' => 0.00 }
  end

  def name(row)
    { 'name' => row.grep_first(/name/i) }
  end

  def description(row)
    { 'description' => row.grep_first(/description/i) || '' }
  end

  def sku(row)
    { 'sku' => row.grep_first(/sku/i) }
  end

  def upc(row)
    # Check this expression @ sku
    { 'upc' => row.grep_first(/upc\s*(code)?\s*$/i) }
  end

  def shipping_category(row)
    { 'shipping_category' => row.grep_first(/shipping category/i) }
  end

  # Not defined, as specified by the readme
  # def options(row)
  # end

  def id(row)
    { 'id' => row.grep_first(/sku/i).to_s + row.grep_first(/brand/i).to_s }
  end

  def available_on(row)
    { 'available_on' => Date.today.iso8601 }
  end
end
