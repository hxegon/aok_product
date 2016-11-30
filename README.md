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
[{ url: 'http://imgur.com/bbqrofllmao', title: 'Image 1' }, { url: 'http://imagebucket.com/foobiebelch?=barbazlol', title: 'Image 2'}]
```
- '&&' is the image url separator  
- The images are just titled according to their order. First image is 'Image 1', second is 'Image 2', and so on...

### Attributes
Needs further discussion. Best idea so far:
- Header: @<attribute-name> (i.e. '@barsize')

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
