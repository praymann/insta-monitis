# Insta-Monitis

A simple ruby CLI which enables the quick creation or listing of tests in a Monitis account.

Leverages v3 of the Monitis API.

TODO:
* Flesh out search (by id, by url, by name)
* Flesh out creation of tests from a set of defaults, given a url/etc
* Set defaults via YAML?
* Flesh out bulk creation via .csv?
* Clean up Configurator Module
* Comments, Comments, Comments
* Error handling

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'insta-monitis'
```

And then execute:

    ~> bundle

Or install it yourself as:

    ~> gem install insta-monitis

## Setup / Credentials

Create a file called .monitis in your $HOME.

It should contain your API key and secret, like so:
    ~> cat ~/.monitis 
    key: RANDOMSTRINGOFRANDOMNESS
    secret: THISISSUPERSECRET
    ~>

## Usage

Help menu:
```ruby
~> insta-monitis
Commands:
  insta-monitis add <subcommand> <args>     # Perform add operations
  insta-monitis help [COMMAND]              # Describe available commands or one specific command
  insta-monitis list <subcommand> <args>    # Perform list operations
  insta-monitis search <subcommand> <args>  # Perform search operations

Options:
  [--verbose], [--no-verbose] 
```
List:
```ruby
~> insta-monitis list
Commands:
  insta-monitis list help [COMMAND]             # Describe subcommands or one specific subcommand
  insta-monitis list list all --style=[STYLE]   # List all tests, sorted by id
  insta-monitis list list http --style=[STYLE]  # List all http tests
  insta-monitis list list page --style=[STYLE]  # List all full page load tests

Options:
  [--style=STYLE]  # Style of output, yaml:json:hash
                   # Default: yaml

~> insta-monitis list help all
Usage:
  insta-monitis list all --style=[STYLE]

Options:
  [--style=STYLE]  # Style of output, yaml:json:hash
                   # Default: yaml

Description:
  Using the API, list every single monitor of any type. Sorted by id
```
Add:
```ruby

```

Search:
```ruby

```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/praymann/insta-catchpoint/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
