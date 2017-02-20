require_relative '../../lib/extractor'

class DummyExtractor < AbstractExtractor
  add_steps %i(id foo)

  define_step(:id) do |row|
    row
  end
end

RSpec.describe DummyExtractor do
  let(:d_ext) { DummyExtractor.new }

  it 'defines id' do
    expect(d_ext.id('slug')).to eq('id' => 'slug')
  end

  context '#extract' do
    it 'fails with NotImplementedError' do
      expect { d_ext.extract(:_) }.to raise_error(NotImplementedError)
    end
  end
end

class CompleteDummyExtractor < AbstractExtractor
  add_steps %i(foo bar)

  define_step(:foo) do |_|
    'foo'
  end

  define_step(:bar) do |_|
    'bar'
  end
end

RSpec.describe CompleteDummyExtractor do
  let(:d_ext) { CompleteDummyExtractor.new }

  context '#extract' do
    it 'finishes extracting in the right output format' do
      expect(d_ext.extract(:_)).to eq({ 'foo' => 'foo', 'bar' => 'bar' })
    end
  end
end
