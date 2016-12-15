require_relative 'image_converter'
require_relative 'extractor'

module AOKExtractor
  def aok_extractor
    # ... extractor code
    new(:aok).tap do |e|
      e.add(name: :taxons) do |row|
        { 'taxons' =>
          row.keys.grep(/taxon/i).map do |k|
            row[k].split('&&')                                     # Split taxon strings
                  .map { |taxon_string| taxon_string.split('//') } # Split to taxon chain
          end.flatten(1)                                           # turn [ [ [taxon chain] ] ] to [ [taxon chain] ]
        }
      end

      e.add(name: :images) do |row|
        ImageConverter.convert(row)
      end

      e.add(name: :properties) do |row|
        { 'properties' =>
          row.select { |(header, _)| header[0] == '@' } # find cells with attribute headers
             .map { |k, v| [k.sub(/@/, ''), v] }        # remove attr identifier char: '@'
             .map { |hash_arr| Hash[*hash_arr] }        # convert Hash map output (Array of Arrays) to Array of Hashes
             .reduce(&:merge)                           # merge Array of Hashes into single hash
        }
      end

      e.add(name: :brand) do |row|
        { 'brand' => row[row.keys.grep(/brand/i).first] }
      end

      e.add(name: :price) do |row|
        # Because this is something that should be:
        # a) Completely unambiguous
        # b) Clear and visible as much as possible
        # I'm going to have this raise NotImplementedError, to force the caller to implement it
        # in a more visible place
        raise NotImplementedError, "price extraction should be defined (with #add) by the caller :)"
      end

      e.add(name: :cost) do |row|
        # Because this is something that should be:
        # a) Completely unambiguous
        # b) Clear and visible as much as possible
        # I'm going to have this raise NotImplementedError, to force the caller to implement it
        # in a more visible place
        raise NotImplementedError, "cost extraction should be defined (with #add) by the caller :)"
      end

      e.add(name: :title) do |row| # named :title, rather than :name, because :name is a reserved lookup symbol in Extractor
        { 'name' => row[row.keys.grep(/title/i).first] }
      end

      e.add(name: :description) do |row|
        { 'description' => row[row.keys.grep(/description/i).first] }
      end

      e.add(name: :sku) do |row|
        { 'sku' => row[row.keys.grep(/sku/i).first] }
      end

      e.add(name: :upc) do |row|
        # Check this expression @ sku
        { 'ucp' => row[row.keys.grep(/upc\s*(code)?\s*$/i).first] }
      end

      # Not defined, as specified by the readme
      # e.add(name: :options) do |row|
      # end
    end
  end
end

class Extractor
  extend AOKExtractor
end
