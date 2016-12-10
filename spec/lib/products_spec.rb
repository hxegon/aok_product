require_relative '../../lib/products'

Source    = AOK::Products::Source

RSpec.describe Source do
  context 'DEFAULT_TRANSFORMER' do
    it 'transforms an example input row to the correct output hash' do
      # TODO
      input_row_text =
        ""
      expected_product =
        [{}]
      expect(Source.new(input_row_text).products).to eq expected_product
    end
  end
end
