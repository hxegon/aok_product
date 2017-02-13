require_relative '../../lib/image_converter'

IC = ImageConverter
RSpec.describe IC do
  context '#convert' do
    it 'returns a whole row, with just the images converted' do
      image_urls = %w(http://imgur.com/bbqrofllmao http://imagebucket.com/foobiebelch?=barbazlol)
      expected = [
        { 'title' => 'Image 1', 'url' => image_urls[0] },
        { 'title' => 'Image 2', 'url' => image_urls[1] }
      ]

      expect(IC.convert(image_urls)).to eq expected
    end
  end

  context '#clean' do
    it 'deencodes the url' do
      dirty_url = 'http://husqvarnacdn.net//qs_mh=710&mw=710//forest%20saw%20mills/chain%20saws/h110-0324.jpg'
      clean_url = URI.decode(dirty_url)

      expect(IC.clean(dirty_url)).to eq clean_url
    end

    it 'replaces .ashx with .jpg' do
      dirty_url = 'https://i.imgur.com/BAbXpMz.ashx'
      clean_url = 'https://i.imgur.com/BAbXpMz.jpg'

      expect(IC.clean(dirty_url)).to eq clean_url
    end
  end
end
