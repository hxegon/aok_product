require_relative '../../lib/transformer_set'

TS = TransformerSet

RSpec.describe TS do
  before(:each) do
    @ts = TS.new
    @ts.add(:foo) { |_| 'foo' }
  end

  context '#add' do
    it 'overrides old transformers with new ones' do
      @ts.add(:foo) { |_| 'bar' }
      expect(@ts.call(nil)).to eq 'bar'
    end
  end

  context '#remove' do
    context 'when the specified lambda exists' do
      it 'removes it, returns the lambda' do
        remove_val = @ts.remove(:foo)

        expect(@ts[:foo]).to be_nil
        expect(remove_val.call(nil)).to eq 'foo'
      end
    end

    context 'when the specified doesn\'t lambda exist' do
      it 'returns nil' do
        expect(@ts.remove(:doesnt_exist)).to be_nil
      end
    end
  end

  context '#generate' do
    it 'returns a TS with the transformers added in the block' do
      @ts.generate do |t|
        t.add(:bar) { |_| 'bar' }
      end

      expect(@ts[:bar].call(nil)).to eq 'bar'
      expect(@ts[:foo].call(nil)).to eq 'foo' # foo should still exist
    end
  end

  context '#call' do
    it 'applies all added functions' do
      ts = TS.new.generate do |t|
        t.add(:plus_one) { |i| i + 1 }
        t.add(:plus_two) { |i| i + 2 }
      end
      expect(ts.call(0)).to eq 3
    end
  end
end
