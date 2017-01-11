## Usage

Make sure you have docker installed on your system.
if you run ```docker-compose version```, your version should be at least 1.6

For the dev container:
```bash
# to build the image
docker build -f dev.df -t aok_product:dev .
# to run it
docker-compose run --rm aok_product_dev
```

## Documentation
TODO link this
Bug me if I haven't linked this yet, but I have to finish writing the yard doc comments.

## Format Design

### Taxons
- Header: taxons  
- example cell: 'toplevelcat//subcat&&othertoplevelcat//othersubcat'  
- example cell category structure:  
```ruby
[['toplevelcat', 'subcat'], ['othertoplevelcat', 'othersubcat']]
```
- '//' is the taxonomy path separator, similar to the *nix directory separator '/'  
- '&&' separates multiple categories.  

Enhancement idea: Make browsing and selecting taxons easier. A program that feeds a csv
containing all taxons, feeds it to an erb template that outputs them in a table
with 'copy to clipboard' buttons next to each row. Run it through the
template, produce a web page file, and search through the file with Ctrl+f.
This should speed up the task of adding taxons significantly.

### Images  
- Header: images  
- example cell: 'http://imgur.com/bbqrofllmao&&http://imagebucket.com/foobiebelch?=barbazlol'  
- example output:   
```ruby
{ 'images' => [{ url: 'http://imgur.com/bbqrofllmao', title: 'Image 1' }, { url: 'http://imagebucket.com/foobiebelch?=barbazlol', title: 'Image 2'}] }
```
- '&&' is the image url separator  
- The images are just titled according to their order. First image is 'Image 1', second is 'Image 2', and so on...

### Properties
- Header: @<properties-name> (i.e. '@barsize')
- *THE HEADER IS CASE SENSITIVE*
- Cell: '28"'

### Brand
- Header: Brand
- example cell: 'Husqvarna'
- Will the brand names be just the full name, or a brand name 'code'? i.e. 'husq' = 'Husqvarna'

### Price
- Header: 'price'
- example cell: '12.99'
- The price that appears on the website.

### Cost
- Header: 'cost'
- example cell: '10.53'
- Doesn't appear on the website

### Name
- Header: 'name'  
- The title that appears on thumbnails, the top of product pages

### Description
- header: 'description'
- The longform description of the item.

### SKU
- header: 'sku'

### UPC
- header: 'upc'

### ~~Options~~
Aren't included for right now, but might be at some point in the future.
