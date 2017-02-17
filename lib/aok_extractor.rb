require_relative 'extractor'
require_relative 'string_normalize'
require_relative 'image_converter'

# NOTES:
# Should NIL_FIELD_REGEXP, the attribute header detection logic, taxon
# separator, image separator, and so on be moved to some module/class? Sort of
# the "<s>domain</s>format logic".

# TODO: Extract to separate file.
module HashGrepFirst
  refine Hash do
    # Grep through hash keys for a given regex, and return the val of the first
    # matching key.
    def grep_first(pattern)
      self[keys.grep(pattern).first]
    end
  end
end

module FlowlinkSteps
  REQUIRED_STEPS = Set[
                       :taxons,
                       :images,
                       :properties,
                       :brand,
                       :price,
                       :cost,
                       :name,
                       :description,
                       :sku,
                       :upc,
                       :shipping_category,
                       :id,
                       :available_on
  ]
end

class AOKExtractor < AbstractExtractor
  using HashGrepFirst
  include FlowlinkSteps # Defines DEFAULT_STEPS

  DEFAULT_IMAGE = 'https://i.imgur.com/BAbXpMz.jpg'.freeze
  NIL_FIELD_REGEXP = /\A\s*x?\s*\z/i

  add_steps(REQUIRED_STEPS)

  define_step(:taxons) do |row|
    row.keys.grep(/taxon/i).map do |taxon_key|
      row[taxon_key].split('&&')                         # Split taxon strings
        .map { |taxon_string| taxon_string.split('//') } # Split to taxon chain
    end.flatten(1)                                       # turn [ [ [taxon chain] ] ] to [ [taxon chain] ]
  end

  define_step(:properties) do |row|
    row.select { |header, _| header[0] == '@' }     # find cells with attribute headers
       .reject { |_, val| val =~ NIL_FIELD_REGEXP } # check is only x and or whitespace
       .map { |(k, v)| [k.sub(/@/, ''), v] }        # remove attr identifier char: '@'
       .map { |hash_arr| Hash[*hash_arr] }          # convert Hash map output (Array of Arrays) to Array of Hashes
       .reduce(&:merge) || {}                       # merge Array of Hashes into single h
  end

  define_step(:brand) do |row|
    row.grep_first(/brand/i)
  end

  define_step(:price) do |row|
    Float(row.grep_first(/price/i))
  end

  define_step(:cost) do |_|
    0.0
  end

  define_step(:name) do |row|
    row.grep_first(/name/i)
  end

  define_step(:description) do |row|
    row.grep_first(/description/i) || ''
  end

  define_step(:sku) do |row|
    row.grep_first(/sku/i)
  end

  define_step(:upc) do |row|
    # Check this expression @ sku
    row.grep_first(/upc\s*(code)?\s*$/i)
  end

  define_step(:shipping_category) do |row|
    row.grep_first(/shipping category/i)
  end

  define_step(:id) do |row|
    row.grep_first(/sku/i).to_s + row.grep_first(/brand/i).to_s
  end

  define_step(:available_on) do |_|
    Date.today.iso8601
  end

  define_step(:images) do |row|
    raw_images = row.grep_first(/images/i)&.split('&&')
    ImageConverter.clean_convert(raw_images || DEFAULT_IMAGE)
  end

  # Not defined, as specified by the readme
  # define_step(:options) do |row|
  # end
end
