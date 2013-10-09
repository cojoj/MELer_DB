MELer_DB
========

It is the SQLite database generator for my spare time project called [MELer](https://github.com/cojoj/MELer).
This generator uses JSON data provided by [MELer Scraper](https://github.com/cojoj/MEL_Scraper).

**How does it work?**
It's pretty simple. Serializes preloaded JSON file and writes it to the Core Data. After that we're free to
copy `.sqlite` file into our iOS application and from that point use this database as data source.
