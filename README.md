# Insta-Monitis

A simple ruby CLI which enables the quick creation or listing of tests in a Monitis account.

Leverages v3 of the Monitis API.

TODO:
* Flesh out creating .monitis via API call with username/password
* Add functionality to manage Pages/Organization in Monitis dashboard UI
* Build out Testing via Rake/etc.
* Comments, Comments, Comments
* Error handling

## Requirements

Requires rubygems thor and bundler.

Install with:

    ~> gem install thor

    ~> gem install bundler

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
  insta-monitis list all --style=[STYLE]   # List all tests, sorted by id
  insta-monitis list http --style=[STYLE]  # List all http tests
  insta-monitis list page --style=[STYLE]  # List all full page load tests

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
~> insta-monitis add
Commands:
  insta-monitis add bulk --file=[FILE]  # Via file, create one or many test(s)
  insta-monitis add help [COMMAND]      # Describe subcommands or one specific subcommand
  insta-monitis add http                # Interactively create a http test
  insta-monitis add page                # Interactively create a full page load test

~> insta-monitis add help bulk
Usage:
  insta-monitis bulk --file=[FILE]

Options:
  -f, [--file=FILE]  # Filename to load

Description:
  Load in a file full of test(s), use the API to created them in Monitis.

```
The --file option will only accept a .csv file. The .csv needs to contain the headers like so:

    type,name,url,interval,timeout,locationIds,tag,checkInterval
    http,this_is_a_http,http.com,,,1 8 10,http!,,,
    fullpage,this_is_a_page,fullpage.com,,,1 8 10,fullpage!,1 1 1,,,
    fullpage,asfd,asdf,asdf,9, ,9, , , 

Type is a required header, as is name, url, locationIds, and tag.

If type is fullpage, checkInterval is required as well and must match the locationIds.

locationIds and checkInterval should be ' ' seperated values.


Delete:
```ruby
~> insta-monitis del 
Commands:
  insta-monitis del help [COMMAND]  # Describe subcommands or one specific subcommand
  insta-monitis del http --id=[ID]  # Delete the http test with given Id
  insta-monitis del page --id=[ID]  # Delete the full page load test with given Id

Options:
  -i, [--id=N]  # Id of test
```

Search:
```ruby
~> insta-monitis search
Commands:
  insta-monitis search help [COMMAND]                           # Describe subcommands or one specific subcommand
  insta-monitis search http --[OPTION]=[VALUE] --style=[STYLE]  # Search all http tests
  insta-monitis search page --[OPTION]=[VALUE] --style=[STYLE]  # Search all fullpage tests

Options:
  -s, [--style=STYLE]  # Style of output, yaml:json:hash
                       # Default: yaml
  -i, [--id=N]         # Id of test
  -n, [--name=NAME]    # Name of test
  -u, [--url=URL]      # URL of test
  -t, [--tag=TAG]      # Tag of test(s)
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
