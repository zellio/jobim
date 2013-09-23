# Jobim

`jobim` is a small ruby utility to pop-up an HTTP server on top of any given
directory. `jobim` leverages [Thin](//github.com/macournoyer/thin/) and offers a
limited subset of the `thin` utilities for your convenience.

## Installation

`jobim` is registered on [rubygems](//rubygems.org/gems/jobim) and is therefore
available anywhere good gems are sold.

``` shell
gem install jobim
```

## Usage

`jobim` is run like `thin` with no configure script.

``` shell
jobim path/to/webroot
```
The site can then be view at `http://localhost:5634`

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Copyright

Copyright (c) 2013 Zachary Elliott. See [LICENSE](/LICENSE) for further details.
