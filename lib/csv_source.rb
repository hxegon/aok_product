require 'csv'

class CSVSource
  def self.from_file(filename)
    new(File.read(filename))
  end

  def initialize(text)
    empty_row_rgx = /^[,"\s]*$/
    @products = CSV.parse(text, headers: true, skip_lines: empty_row_rgx, row_sep: :auto)
  end

  def each
    @products.each { |p| yield p.to_hash }
  end
end
