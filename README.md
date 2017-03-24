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

| Header Format | Description | Cell Formatting Example | Note |
| --- | --- | ---- | --- |
| taxons | Taxons | toplevelcat//subcat&&othertoplevelcat//othersubcat | "//" Is the path separator, use "&&" to add another taxon path |
| images | Images | http://imgur.com/bbqrofllmao&&http://imagebucket.com/foobiebelch?=barbazlol | use "&&" to separate urls. Main image should be first |
| @property-name | Properties | (for @bar-length) 28" | |
| brand | Brand | Husqvarna | |
| price | Price | 12.99 | How much the customer pays for the item |
| cost | Cost | 10.53 | |
| name | The listing title | "460 Rancher" | |
| description | Longform item description | An excellent chainsaw that you totally shouldn't use to cut roots <etc> | |
| sku | SKU | | |
| upc | UPC | | |
