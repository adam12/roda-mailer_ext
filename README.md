# Roda Mailer Extensions

A few helpful extensions to the Roda mailer plugin.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "roda-mailer_ext"
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install roda-mailer_ext

## Usage

Simply configure this plugin as you would any other plugin. Without any options,
the plugin is a no-op. You will want to use the `log` or `prevent_delivery` options
to make the plugin useful.

I like to pair this plugin with the [environments](http://roda.jeremyevans.net/rdoc/classes/Roda/RodaPlugins/Environments.html)
plugin to configure depending on current `RACK_ENV`.

    plugin :environments
    plugin :mailer_ext,
      log: (development? or production?),
      prevent_delivery: !production?

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/adam12/roda-mailer_ext.

I love pull requests! If you fork this project and modify it, please ping me to see
if your changes can be incorporated back into this project.

That said, if your feature idea is nontrivial, you should probably open an issue to
[discuss it](http://www.igvita.com/2011/12/19/dont-push-your-pull-requests/)
before attempting a pull request.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
