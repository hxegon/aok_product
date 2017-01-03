require 'csv'

class CSVSource
  def self.from_file(filename)
    new(File.read(filename))
  end

  def initialize(text)
    @products = CSV.parse(text, headers: true, row_sep: :auto)
  end

  def each
    @products.each { |p| yield p.to_hash }
  end
end
