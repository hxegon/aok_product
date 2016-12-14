require_relative '../../lib/rewrite/extractor'

RSpec.describe Extractor do
  before(:each) do
    @ex = Extractor.new(:foo)
    @ex.add(name: :foo) { |_| 'foo' }
  end

  context '#add' do
    it 'causes #steps to be non-empty' do
      e = Extractor.new(:foo)
      e.add(name: :bar) { |_| 'bar' }
      expect(e.steps.size).to eq 1
    end

    it 'overrides old transformers with new ones' do
      @ex.add(name: :foo) { |_| 'bar' }
      expect(@ex.extract(nil)).to eq ['bar']
    end
  end

  context '#delete' do
    context 'when the specified step exists' do
      it 'deletes it, returns the step' do
        deleted_val = @ex.delete(:foo)

        expect(@ex[:foo]).to be_nil
        expect(deleted_val[:block].call(nil)).to eq 'foo'
      end
    end

    context 'when the specified doesn\'t step exist' do
      it 'returns nil' do
        expect(@ex.delete(:doesnt_exist)).to be_nil
      end
    end
  end

  context '#extract' do
    it 'applies all added functions' do
      ex = Extractor.new(:foo).tap do |e|
        e.add(name: :plus_one) { |i| i + 1 }
        e.add(name: :plus_two) { |i| i + 2 }
      end
      expect(ex.extract(0).reduce(&:+)).to eq 3
    end
  end
end
