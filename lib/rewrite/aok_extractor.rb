require_relative '../image_converter'
require_relative 'extractor'

module AOKExtractor
  def self.aok_extractor
    # ... extractor code
    new.tap do |e|
      e.add(:taxons) do |row|
      end

      e.add(:images) do |row|
        ImageConverter.convert(row)
      end

      e.add(:attributes) do |row|
        row.tap do |r| # wrap []= so we return the entire hash
          r['properties'] =
            r.select { |(header, _)| header[0] == '@' } # find cells with attribute headers
            .map { |k, v| [k.remove('@'), v] }          # remove attr identifier char: '@'
            .map { |hash_arr| Hash[hash_arr] }          # convert Hash map output (Array of Arrays) to Array of Hashes
            .reduce(&:merge)                            # merge Array of Hashes into single hash
        end 
      end

      e.add(:brand) do |row|
      end

      e.add(:price) do |row|
      end

      e.add(:cost) do |row|
      end

      e.add(:name) do |row|
      end

      e.add(:description) do |row|
      end

      e.add(:sku) do |row|
      end

      e.add(:upc) do |row|
      end
    end
  end
end

class Extractor
  extend AOKExtractor
end
