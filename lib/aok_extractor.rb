require_relative 'image_converter'
require_relative 'extractor'

module AOKExtractor
  def self.aok_extractor
    # ... extractor code
    new.tap do |e|
      e.add(:taxons) do |row|
        row.keys.grep(/taxon/i).map do |k|
            row[k].split('&&')                                     # Split taxon strings
                  .map { |taxon_string| taxon_string.split('//') } # Split to taxon chain
          end.flatten(1)                                           # turn [ [ [taxon chain] ] ] to [ [taxon chain] ]
      end

      e.add(:images) do |row|
        ImageConverter.convert(row)
      end

      e.add(:properties) do |row|
        row.tap do |r| # wrap []= so we return the entire hash
          r['properties'] =
            r.select { |(header, _)| header[0] == '@' } # find cells with attribute headers
             .map { |k, v| [k.remove('@'), v] }         # remove attr identifier char: '@'
             .map { |hash_arr| Hash[hash_arr] }         # convert Hash map output (Array of Arrays) to Array of Hashes
             .reduce(&:merge)                           # merge Array of Hashes into single hash
        end
      end

      e.add(:brand) do |row|
        row[row.keys.grep(/brand/i).first]
      end

      e.add(:price) do |row|
        # Because this is something that should be:
        # a) Completely unambiguous
        # b) Clear and visible as much as possible
        # I'm going to have this raise NotImplementedError, to force the caller to implement it
        # in a more visible place
        raise NotImplementedError, "price extraction should be defined (with #add) by the caller :)"
      end

      e.add(:cost) do |row|
        # Because this is something that should be:
        # a) Completely unambiguous
        # b) Clear and visible as much as possible
        # I'm going to have this raise NotImplementedError, to force the caller to implement it
        # in a more visible place
        raise NotImplementedError, "cost extraction should be defined (with #add) by the caller :)"
      end

      e.add(:name) do |row|
        row[row.keys.grep(/title/i).first]
      end

      e.add(:description) do |row|
        row[row.keys.grep(/description/i).first]
      end

      e.add(:sku) do |row|
        row[row.keys.grep(/sku/i).first]
      end

      e.add(:upc) do |row|
        # Check this expression @ sku
        row[row.keys.grep(/upc\s*(code)?\s*$/i).first]
      end

      # Not defined, as specified by the readme
      # e.add(:options) do |row|
      # end
    end
  end
end

class Extractor
  extend AOKExtractor
end
