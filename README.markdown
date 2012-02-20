TruncateHtml
============

[![Build Status](https://secure.travis-ci.org/hgimenez/truncate_html.png?branch=master)](http://travis-ci.org/hgimenez/truncate_html)

truncate_html is a Rails helper plugin that [cuts off](http://www.youtube.com/watch?v=6XG4DIOA7nU) a string of HTML and takes care of closing any lingering open tags. There are many possible solutions to this. This plugin does not have any dependencies, and does all it's work via [regular expressions](http://xkcd.com/208/).

The API is very similar to Rails' own <code>truncate()</code> method.


Example
-------

    some_html = '<ul><li><a href="http://whatever">This is a link</a></li></ul>'
    truncate_html(some_html, :length => 15, :omission => '...(continued)')
      => <ul><li><a href="http://whatever">This...(continued)</a></li></ul>

A few notes:

* By default, it will truncate on word boundary.
  To truncate the HTML string strictly at the specified length, pass in the `:word_boundary => false` option.
* If the input HTML is nil, it will return an empty string.
* The omission text's length does count toward the resulting string's length.
* `<script>` tags will pass right through - they will not count toward the resulting string's length, or be truncated.
* The default options are:
  * :length => 100
  * :omission => '...'
  * :word_boundary => true

You may also set global configuration options.
For example, place the following on a sensible place,
like `config/initializers/truncate_html.rb`

    TruncateHtml.configure do |config|
      config.length       = 50
      config.omission     = '...(continued)'
      config.word_boundary = false
    end

Installation
------------

The latest gem version for the Rails 2.x series is 0.3.2.
To use truncate_html on a Rails 2 app, please install the 0.3.2 version:

    gem install truncate_html -v 0.3.2

For Rails 3, use the latest truncate_html:

    gem install truncate_html

Issues or Suggestions
---------------------

Found an issue or have a suggestion? Please report it on [Github's issue tracker](http://github.com/hgimenez/truncate_html/issues).

Testing
-------

    bundle
    rake

All green? Go hack.

Copyright (c) 2009 - 2010 Harold A. Giménez, released under the MIT license

Thanks to all the [contributors](https://github.com/hgimenez/truncate_html/contributors)!
