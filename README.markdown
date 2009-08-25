TruncateHtml
============

truncate_html is a Rails helper plugin that [cuts off](http://www.youtube.com/watch?v=6XG4DIOA7nU) a string of HTML and takes care of closing any lingering open tags. There are many possible solutions to this. This plugin does not have any dependencies, and does all it's work via [regular expressions](http://xkcd.com/208/).

The API is very similar to Rails' own truncate method.


Example
-------

    some_html = '<ul><li><a href="http://whatever">This is a link</a></li></ul>'

    truncate_html(some_html, :length => 5, :omission => '...(continued)')

      => <ul><li><a href="http://whatever">This is...(continued)</a></li></ul>


A few notes:

* It will truncate on a word boundary.
* The default options are:
  * :length => 100
  * :omission => '...'

Installation
------------

#### As a gem
Add this to your <code>config/environment.rb</code>:

    config.gem 'truncate_html',
      :source => 'http://gemcutter.org'

Then either
<code>sudo rake gems:install</code>
or
<code>sudo gem install truncate_html</code>

#### As a plugin:
<code>script/plugin install git://github.com/hgimenez/truncate_html.git</code>

Issues
------

Found an issue? Please report it on [Github's issue tracker](http://github.com/hgimenez/truncate_html/issues).

Testing
-------

The plugin is tested using RSpec. [Install it](http://wiki.github.com/dchelimsky/rspec/rails) on your app if you wish to run the tests.

Copyright (c) 2009 Harold A. Giménez, released under the MIT license
