require_relative '../../lib/image_converter'

IC = ImageConverter
RSpec.describe IC do
  context '#call' do
    it 'returns a whole row, with just the images converted' do
      image_urls = %w(http://imgur.com/bbqrofllmao http://imagebucket.com/foobiebelch?=barbazlol)
      expected = [
        { 'title' => 'Image 1', 'url' => image_urls[0] },
        { 'title' => 'Image 2', 'url' => image_urls[1] }
      ]

      expect(IC.convert(image_urls)).to eq expected
    end
  end
end
