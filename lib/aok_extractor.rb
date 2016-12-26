require_relative 'image_converter'
require_relative 'extractor'

class AOKExtractor < Extractor
  def taxons(row)
    { 'taxons' =>
      row.keys.grep(/taxon/i).map do |k|
        row[k].split('&&')                                     # Split taxon strings
          .map { |taxon_string| taxon_string.split('//') } # Split to taxon chain
      end.flatten(1)                                           # turn [ [ [taxon chain] ] ] to [ [taxon chain] ]
    }
  end

  def images(row)
    raw_images = row[row.keys.grep(/images/i).first]
    { 'images' => ImageConverter.convert(raw_images || 'https://i.imgur.com/BAbXpMz.jpg') } # TMP: Give cheeky 404 image if raw_images is nil
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
    { 'brand' => row[row.keys.grep(/brand/i).first] }
  end

  def price(row)
    # Because this is something that should be:
    # a) Completely unambiguous
    # b) Clear and visible as much as possible
    # I'm going to have this raise NotImplementedError, to force the caller to implement it
    # in a more visible place
    { 'price' => Float(row[row.keys.grep(/price/i).first]) }
  end

  def cost(row)
    # Because this is something that should be:
    # a) Completely unambiguous
    # b) Clear and visible as much as possible
    # I'm going to have this raise NotImplementedError, to force the caller to implement it
    # in a more visible place
    { 'cost' => 0.00 }
  end

  def name(row)
    { 'name' => row[row.keys.grep(/name/i).first] }
  end

  def description(row)
    { 'description' => row[row.keys.grep(/description/i).first] }
  end

  def sku(row)
    { 'sku' => row[row.keys.grep(/sku/i).first] }
  end

  def upc(row)
    # Check this expression @ sku
    { 'upc' => row[row.keys.grep(/upc\s*(code)?\s*$/i).first] }
  end

  # Not defined, as specified by the readme
  # def options(row)
  # end
end
