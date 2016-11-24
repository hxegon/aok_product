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

### Brand
### Price
### Cost
### Name
### Description
### SKU
### UPC
### Attributes
### ~~Options~~
