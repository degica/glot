# Glot

### The locale manager for rails
#### and all other things in config/locale

Tired of looking for keys nested deep inside your language files? Tired of looking for the right places and finding the right alphabetically ordered spot in your locale files to insert your new entry? Tired of manually looking through your language files to diff them? Tire no longer, glot is here!

With glot you can sort your language files:

```
$ glot sort
```

You can easily add a key to all your language files too, just go

```
$ glot add activerecord.fireworks.explode
["en"]
"activerecord.fireworks.explode"
["ja"]
"activerecord.fireworks.explode"
```

and you will see an addition to all your language files:

```yml
en:
  activerecord:
    fireworks:
      explode: TRANSLATE_ME
```

Can't find something in your 10000000 lines of translations?

```
glot find explode
{:path=>"en.explode", :v=>"bewm"}
{:path=>"en.activerecord.fireworks.explode", :v=>"Explode beautifully"}
```

Afraid you forgot to translate something?

```
$ glot translate_mes
en.activerecord.fireworks.explode
```

Want to see the difference between language files?

```
$ glot diff

en
-----------------------
ja
=======================

ja
-----------------------
activerecord.fireworks.put_out
=======================
```

Oops! Japanese is missing a `put_out` translation! Time to add it in:

```
$ glot add activerecord.fireworks.put_out
```

It will not overwrite existing translations.

You can also diff language files individually:

```
$ glot diff ja

ja
-----------------------
activerecord.fireworks.put_out
=======================
```


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'glot'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install glot

## Usage

Sort translations

    glot sort

Insert a translation path with a dummy value 'TRANSLATE_ME'

    glot add <activerecord.payment.some.translation.key>

Find the exact path of a phrase in the translation files

    glot find <thing>

Find paths that still have TRANSLATE_ME in them

    glot translate_mes

Find paths that are missing in each file [or the language chosen]

    glot diff [lang]


Find paths that are missing in each file [or the language chosen] and fill it in

    glot diff [lang] --fill

## Known issues

See the issues tab for known issues with glot. Pull requests welcome to fix them!

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/degica/glot. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Glot project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/degica/glot/blob/master/CODE_OF_CONDUCT.md).
