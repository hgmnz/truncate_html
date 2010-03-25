TruncateHtml
============

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

#### As a gem
Add this to your <code>config/environment.rb</code>:

    config.gem 'truncate_html',
      :source => 'http://gemcutter.org'

Then either
<code>rake gems:install</code>
or
<code>gem install truncate_html</code>

#### As a plugin:
<code>script/plugin install git://github.com/hgimenez/truncate_html.git</code>

Issues or Suggestions
---------------------

Found an issue or have a suggestion? Please report it on [Github's issue tracker](http://github.com/hgimenez/truncate_html/issues).

Testing
-------

Make sure the following gems are installed

    rspec
    rpsec-rails
    rails > 2.3.4

Clone the repo and run rake from the project's root. All green? Go hack.

Copyright (c) 2009 - 2010 Harold A. Giménez, released under the MIT license
