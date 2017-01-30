# KVDAG

Implements a Directed Acyclic Graph for Key-Value searches.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'kvdag'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install kvdag

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install
dependencies. Then, run `rake spec` to run the tests. You can also run
`bin/console` for an interactive prompt that will allow you to
experiment.

To install this gem onto your local machine, run `bundle exec rake
install`.

## Contributing

We are happy to accept contributions in the form of issues and pull
requests on
[GitHub](https://github.com/saab-simc-admin/keyvaluedag). Please
follow these guidelines to make the experience as smooth as possible:

- All development takes place in feature branches, with master only
  accepting non-fast-forward merges.

- Others shall be able to use the KeyValue DAG library to build their
  own tools. If you introduce API changes, please increment version
  numbers according to [semantic versioning](http://semver.org/).

- All code will be reviewed before it is merged. To help the reviewer,
  send your work as a series of logically separate changes, not as one
  gigantic squash commit. Make sure bisection will work by ensuring
  the code actually works after each change.

- GnuPG sign all your commits and tags, with a key that is [validated
  by
  GitHub](https://help.github.com/articles/about-gpg-commit-and-tag-signatures/).

  - GitHub's web UI cannot generate signed merges when accepting pull
    requests. Instead, we use [a custom
    tool](https://github.com/saab-simc-admin/workflow-tools/tree/master/git-ghpr)
    to accept them. You can still send them through the web as usual.

  - Your code shall be signed by you. Therefore, the maintainer cannot
    fix any merge conflicts arising from your pull request. If there
    are any conflicts, please rebase onto current master before
    sending your pull request.

- Document your work.

  - At an absolute minimum, Ruby code shall have
    [RDoc](https://rdoc.github.io/rdoc/) blocks documenting each
    function.

  - Write your commit messages in the usual Git style: a short summary
    in the first line, then paragraphs of explanatory text, line
    wrapped.

- Test your code.

  - Code shall pass [Rubocop](https://github.com/bbatsov/rubocop) tests. See [.rubocop.yml](.rubocop.yml) for configured options. Rubocop is automaticallly run with the default Rake task.

  - Tests shall be written in [RSpec](http://rspec.info/).

  - Library code shall have unit tests.

  - Tools shall have integration and end-to-end tests.
