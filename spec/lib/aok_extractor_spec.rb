require_relative '../../lib/aok_extractor'

RSpec.describe AOKExtractor do
  let(:aok_e) { AOKExtractor.new }
  
  context 'steps' do
    context ':taxons' do
      it 'returns correct taxon chains from a properly formatted taxon string' do
        chains        = [['Category', 'Chainsaw'], ['Market', 'Homeowner']]
        taxons_string = chains.map { |t_c| t_c.join('//') }.join('&&')
        row           = { 'taxon' => taxons_string }

        expect(aok_e.taxons(row)).to eq({ 'taxons' => chains })
      end
    end

    # context ':images' # since this wraps ImageConverter.convert, test that in its own file.

    context ':properties' do
      it 'works on happy path' do
        row      = { '@foo' => 'bar', '@biz' => 'baz' }
        expected = { 'foo' => 'bar', 'biz' => 'baz' }

        expect(aok_e.properties(row)).to eq({ 'properties' => expected })
      end

      it 'doesn\'t return non-properties' do
        row      = { '@foo' => 'bar', 'something' => 'something' }
        expected = { 'foo' => 'bar', 'biz' => 'baz' }

        expect(aok_e.properties(row)['something']).to be_nil
        expect(aok_e.properties(row)['properties']['something']).to be_nil
      end

      it 'leaves out blank or \'X\'d attributes' do
        row = { '@na_attribute' => '  X', '@blank_attribute' => ' ' }
        expect(aok_e.properties(row))
          .to eq({ 'properties' => {} })
      end
    end

    context ':brand' do
      it 'works on happy path' do
        row      = { 'brand' => 'Husqvarna' }
        expected = row

        expect(aok_e.brand(row)).to eq expected
      end
    end

    context ':price' do
      it 'raises NotImplementedError' do
        # add test here. Now it's implemented.
      end
    end

    context ':cost' do
      it 'raises NotImplementedError' do
        # add test here. Now it's implemented.
      end
    end

    context ':name' do
      it 'returns \'name\' => <name>' do
        row = { 'name' => 'foo' }
        
        expect(aok_e.name(row)).to eq({ 'name' => 'foo' })
      end
    end

    context ':description' do
      it 'works on happy path' do
        row = { 'description' => 'foobie belch' }
        expect(aok_e.description(row)).to eq row
      end
    end

    context ':sku' do
      it 'works on happy path' do
        row = { 'sku' => '123456' }
        expect(aok_e.sku(row)).to eq row
      end
    end

    context ':upc' do
      it 'works on happy path' do
        row = { 'upc' => '123456' }
        expect(aok_e.upc(row)).to eq row
      end
    end

    context ':shipping_category' do
    end

    # context ':options'

    context ':id' do
      let(:row) { { 'brand' => 'Foo Co.', 'sku' => 'BARCODE' } }
      let(:old_id) { aok_e.id(row) }

      # Not really general flowlink id properties, but just our implementation.
      it 'changes if brand changes' do
        old_id = old_id # Seems nonsensical, I know. Let statements can be weird.
        row['brand'] = 'Foo Co. Ltd.'
        expect(aok_e.id(row)).to_not eq old_id
      end

      it 'changes if sku changes' do
        old_id = old_id
        row['sku'] = 'BAZCODE'
        expect(aok_e.id(row)).to_not eq old_id
      end
    end

    context ':available_on' do
      it 'exists' do
        expect(aok_e.available_on({})['available_on']).to_not be_nil
      end
    end

    context ':images' do
      it 'converts .ashx urls to .jpg' do
        row      = { 'images' => 'https://imgur.com/foobie.ashx' }
        actual   = aok_e.images(row)['images'][0]['url']
        expected = 'https://imgur.com/foobie.jpg'

        expect(actual).to eq expected
      end
    end
  end
end
