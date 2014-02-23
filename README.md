# Jobim

[![Gem Version](https://badge.fury.io/rb/jobim.png)](http://badge.fury.io/rb/jobim)
[![Build Status](https://secure.travis-ci.org/zellio/jobim.png?branch=master)](http://travis-ci.org/zellio/jobim)
[![Dependency Status](https://gemnasium.com/zellio/jobim.png)](https://gemnasium.com/zellio/jobim)
[![Code Climate](https://codeclimate.com/github/zellio/jobim.png)](https://codeclimate.com/github/zellio/jobim)

`jobim` is a light utility for generating a static HTTP server. This allows
for rapid website design and development without the hassle and security risk
of a full web-server installation. `jobim` leverages
[Thin](//github.com/macournoyer/thin/) and exposes a limited subset of the
`thin` executable command flags for your convenience in addition to a set of
flags for its own configuration.

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
    -c, --[no-]config [PATH]         Disable config loading or specify path to load from
    -d, --daemonize                  Run as a daemon process
    -p, --port PORT                  use PORT (default: 3000)
    -P, --prefix PATH                Mount the app under PATH
    -q, --quiet                      Silence all logging

General options:
    -h, --help                       Display this help message.
        --version                    Display the version number

Jobim home page: <https://github.com/zellio/jobim/>
Report bugs to: <https://github.com/zellio/jobim/issues>
```

`jobim` is run like `thin` but does not require a configuration script. By
default `jobim` will bind to `0.0.0.0:3000` and serve the current working
directory.

``` shell
jobim path/to/webroot
```

The site can be viewed at `http://localhost:3000` via a normal web browser.

### Configuration Files

`jobim` also allows for the use of a configuration file `.jobim.yml`. This can
be used to set sane defaults for the `jobim` program to use in every
execution. `jobim` will search up from the current working directory until it
reaches `/` in the pursuit of configuration files, with the configuration
options cascading from root to the current working directory. Options passed
as command flags to `jobim` always win.

```
# Example config file
---
:dir: /web_root
:prefix: /foo
:port: 300
```

All options must be specified as key value pairs in a depth one hash. The keys
must be ruby symbols (For historical reasons capitalization of these keys is
irrelevant but they should be all downcase). The valid options are
`:daemonize`, `:dir`, `:host`, `:port`, `:prefix`, `:quiet`, and `:conf_dir`.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Copyright

Copyright (c) 2013-2014 Zachary Elliott. See [LICENSE](/LICENSE) for further
details.
