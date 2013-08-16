TruncateHtml
============

[![Build Status](https://secure.travis-ci.org/hgmnz/truncate_html.png?branch=master)](http://travis-ci.org/hgmnz/truncate_html)
[![Code Climate](https://codeclimate.com/github/hgmnz/truncate_html.png)](https://codeclimate.com/github/hgmnz/truncate_html)

truncate_html cuts off a string of HTML and takes care of closing any lingering open tags. There are many ways to solve this. This library does not have any dependencies, and [parses HTML using regular expressions](http://stackoverflow.com/questions/1732348/regex-match-open-tags-except-xhtml-self-contained-tags/1732454#1732454).

It can be used with or without Rails.

Example
-------

```ruby
some_html = '<ul><li><a href="http://whatever">This is a link</a></li></ul>'
truncate_html(some_html, length: 15, omission: '...(continued)')
  => <ul><li><a href="http://whatever">This...(continued)</a></li></ul>
```

A few notes:

* By default, it will truncate on word boundary.
  To truncate the HTML string strictly at the specified length, pass in the `word_boundary: false` option.
* If the input HTML is nil, it will return an empty string.
* The omission text's length does count toward the resulting string's length.
* `<script>` tags will pass right through - they will not count toward the resulting string's length, or be truncated.

* The default options are:
```
length: 100
omission: '...'
word_boundary: /\S/
```

You may also set global configuration options.
For example, place the following on application boot,
something like `config/initializers/truncate_html.rb`

```ruby
TruncateHtml.configure do |config|
  config.length        = 50
  config.omission      = '...(continued)'
end
```

If you really want, you can even set a custom word boundary regexp.
For example, to truncate at the end of the nearest sentence:

```ruby
TruncateHtml.configure do |config|
  config.word_boundary = /\S[\.\?\!]/
end
```

You can also truncate the HTML at a specific point not based on length but content.
To do that, place the `:break_token` in your source. This allows the truncation to be
data driven, breaking after a leading paragraph or sentence. If the
`:break_token` is in your content before the specified `:length`, `:length` will be
ignored and the content truncated at `:break_token`.
If the `:break_token` is in your content after the specified `:length`,
`:break_token` will be ignored and the content truncated at `:length`.

```ruby
TruncateHtml.configure do |config|
  config.break_token = '<!-- truncate -->'
end
```
Installation
------------

The latest gem version for the Rails 2.x series is 0.3.2.
To use truncate_html on a Rails 2 app, please install the 0.3.2 version:

    gem install truncate_html -v 0.3.2

For Rails 3, use the latest truncate_html:

    gem install truncate_html

Issues or Suggestions
---------------------

Found an issue or have a suggestion? Please report it on [Github's issue tracker](http://github.com/hgmnz/truncate_html/issues).

Testing
-------

```shell
bundle
rake
```

All green? Go hack.

Copyright (c) 2009 - 2010 Harold A. Giménez, released under the MIT license

Thanks to all the [contributors](https://github.com/hgmnz/truncate_html/contributors)!
