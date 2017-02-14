require_relative 'image_converter'
require_relative 'extractor'
require_relative 'string_normalize'

module HashGrepFirst
  refine Hash do
    # Grep through hash keys for a given regex, and return the val of the first
    # matching key.
    def grep_first(pattern)
      self[keys.grep(pattern).first]
    end
  end
end

class AOKExtractor < Extractor
  using HashGrepFirst
  DEFAULT_IMAGE = 'https://i.imgur.com/BAbXpMz.jpg'.freeze
  NIL_FIELD_REGEXP = /\A\s*x?\s*\z/i

  def taxons(row)
    { 'taxons' =>
      row.keys.grep(/taxon/i).map do |k|
        row[k].split('&&')                                 # Split taxon strings
          .map { |taxon_string| taxon_string.split('//') } # Split to taxon chain
      end.flatten(1)                                       # turn [ [ [taxon chain] ] ] to [ [taxon chain] ]
    }
  end

  def images(row)
    raw_images  = row.grep_first(/images/i)&.split('&&')
    { 'images' => ImageConverter.clean_convert(raw_images || DEFAULT_IMAGE) }
  end

  def properties(row)
    { 'properties' =>
      row.select { |header, _| header[0] == '@' }  # find cells with attribute headers
        .reject { |_, val| val =~ NIL_FIELD_REGEXP } # check is only x and or whitespace
        .map { |(k, v)| [k.sub(/@/, ''), v] }        # remove attr identifier char: '@'
        .map { |hash_arr| Hash[*hash_arr] }          # convert Hash map output (Array of Arrays) to Array of Hashes
        .reduce(&:merge) || {}                       # merge Array of Hashes into single hash
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
