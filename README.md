# Jobim

[![Gem Version](https://badge.fury.io/rb/jobim.png)](http://badge.fury.io/rb/jobim)
[![Dependency Status](https://gemnasium.com/zellio/jobim.png)](https://gemnasium.com/zellio/jobim)
[![Code Climate](https://codeclimate.com/github/zellio/jobim.png)](https://codeclimate.com/github/zellio/jobim)

`jobim` is a light utility for generating a static HTTP server. This allows
for rapid website design and development without the hassle and security risk
of a full web-server installation. `jobim` leverages
[Thin](//github.com/macournoyer/thin/) and exposes a limited subset of the
`thin` executable command flags for your convenience.

## Installation

`jobim` is registered on [rubygems](//rubygems.org/gems/jobim) and is
available anywhere good gems are sold.

``` shell
gem install jobim
```

## Usage

```
Usage: jobim [OPTION]... [DIRECTORY]

Specific options:
    -a, --address HOST               bind to HOST address (default: 0.0.0.0)
    -d, --daemonize                  Run as a daemon process
    -p, --port PORT                  use PORT (default: 5634)
    -P, --prefix PATH                Mount the app under PATH
    -q, --quiet                      Silence all logging

General options:
    -h, --help                       Display this help message.
        --version                    Display the version number

Jobim home page: <https://github.com/zellio/jobim/>
Report bugs to: <https://github.com/zellio/jobim/issues>
```

`jobim` is run like `thin` but does not require a configuration script. By
default `jobim` will bind to `0.0.0.0:5634` and serve the current working
directory.

``` shell
jobim path/to/webroot
```

The site can be viewed at `http://localhost:5634` via a normal web browser.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Copyright

Copyright (c) 2013 Zachary Elliott. See [LICENSE](/LICENSE) for further details.
