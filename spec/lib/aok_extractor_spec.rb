require_relative '../../lib/aok_extractor'

RSpec.describe AOKExtractor do
  let(:aok_e) { Extractor.aok_extractor }
  
  context 'steps' do
    context ':taxons' do
      it 'returns correct taxon chains from a properly formatted taxon string' do
        chains        = [['Category', 'Chainsaw'], ['Market', 'Homeowner']]
        taxons_string = chains.map { |t_c| t_c.join('//') }.join('&&')
        row           = { 'taxon' => taxons_string }

        expect(aok_e[:taxons].call(row)).to eq({ 'taxons' => chains })
      end
    end

    # context ':images' # since this wraps ImageConverter.convert, test that in its own file.

    context ':properties' do
      it 'works on happy path' do
        row      = { '@foo' => 'bar', '@biz' => 'baz' }
        expected = { 'foo' => 'bar', 'biz' => 'baz' }

        expect(aok_e[:properties].call(row)).to eq({ 'properties' => expected })
      end

      it 'doesn\'t return non-properties' do
        row      = { '@foo' => 'bar', 'something' => 'something' }
        expected = { 'foo' => 'bar', 'biz' => 'baz' }

        expect(aok_e[:properties].call(row)['something']).to be_nil
        expect(aok_e[:properties].call(row)['properties']['something']).to be_nil
      end
    end

    context ':brand' do
      it 'works on happy path' do
        row      = { 'brand' => 'Husqvarna' }
        expected = row

        expect(aok_e[:brand].call(row)).to eq expected
      end
    end

    context ':price' do
      it 'raises NotImplementedError' do
        expect { aok_e[:price].call(nil) }.to raise_error(NotImplementedError)
      end
    end
    
    context ':cost' do
      it 'raises NotImplementedError' do
        expect { aok_e[:cost].call(nil) }.to raise_error(NotImplementedError)
      end
    end

    context ':title' do
      it 'returns \'name\' => <title>' do
        row = { 'title' => 'foo' }
        
        expect(aok_e[:title].call(row)).to eq({ 'name' => 'foo' })
      end
    end

    context ':description' do
      it 'works on happy path' do
        row = { 'description' => 'foobie belch' }
        expect(aok_e[:description].call(row)).to eq row
      end
    end

    context ':sku' do
      it 'works on happy path' do
        row = { 'sku' => '123456' }
        expect(aok_e[:sku].call(row)).to eq row
      end
    end

    context ':upc' do
      it 'works on happy path' do
        row = { 'upc' => '123456' }
        expect(aok_e[:upc].call(row)).to eq row
      end
    end

    # context ':options'
  end
end