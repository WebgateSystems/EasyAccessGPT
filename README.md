# EasyAccessGPT

Ruby gem for chat, translation, and profanity checks through the OpenAI [chat completions](https://platform.openai.com/docs/api-reference/chat) API.

## Requirements

Ruby 3.3 or newer. The test matrix is Ruby 3.3, 3.4, and 4.0.

## Installation

Add the gem to the application's Gemfile:

```ruby
gem 'easy_access_gpt', git: 'https://github.com/WebgateSystems/EasyAccessGPT.git'
```

Then run `bundle install`.

## Configuration

In a Rails application, set this in `config/initializers/easy_access_gpt.rb`. Elsewhere, `require 'easy_access_gpt'` and then set the same attributes.

```ruby
require 'easy_access_gpt'

EasyAccessGpt::Configure.api_key = 'your api key'
EasyAccessGpt::Configure.gpt_model = 'gpt-5.6-terra'
EasyAccessGpt::Configure.available_locales = %i[de en es fr it pl ru ua]
EasyAccessGpt::Configure.max_tokens = 1000
EasyAccessGpt::Configure.model_url = '/v1/chat/completions'
```

`api_key` has no default. The other assignments above repeat the defaults, so an application only needs to set the values it wants to change.

| Attribute | Default | Sent as |
| --- | --- | --- |
| `gpt_model` | `gpt-5.6-terra` | `model` |
| `max_tokens` | `1000` | `max_completion_tokens` |
| `available_locales` | `de`, `en`, `es`, `fr`, `it`, `pl`, `ru`, `ua` | locales for `Translation::ScopeLocales` |
| `model_url` | `/v1/chat/completions` | path on `https://api.openai.com` |

Every request also sends `reasoning_effort` set to `none`, so reasoning tokens do not consume the completion budget. Filter and both translation calls also send `response_format: { type: 'json_object' }`.

A call that receives an API error returns that payload with `operation: :fail`. A missing or rejected API key fails the same way.

## Usage

### Chat

`Communication` returns the assistant message as a string.

```ruby
EasyAccessGpt::Communication.new('hello').call
# => "Hello! How can I assist you today?"
```

The system message is `You are a helpful assistant.`

### Translation into every configured locale

`Translation::ScopeLocales` asks the model to translate the text into `Configure.available_locales` and returns the parsed JSON object.

```ruby
EasyAccessGpt::Translation::ScopeLocales.new('hello').call
# => { "en" => { "body" => "hello" }, "pl" => { "body" => "cześć" } }
```

Pass a hash when the text has several fields. The model is asked to translate values and keep the keys:

```ruby
EasyAccessGpt::Translation::ScopeLocales.new({ body: 'hello' }).call
```

### Translation into one locale

```ruby
EasyAccessGpt::Translation::SingleLocale.new('hello', :pl).call
# => { "pl" => { "body" => "cześć" } }
```

The second argument is the target locale. It does not have to be one of `available_locales`.

### Profanity check

`Filter` returns parsed JSON with `message_include_profanity`.

```ruby
EasyAccessGpt::Filter.new('hello').call
# => { "message_include_profanity" => false }

EasyAccessGpt::Filter.new('text included bad words').call
# => { "message_include_profanity" => true }
```

## Development

From a checkout of this repository:

```bash
bundle install
bundle exec rake
```

`rake` runs RSpec and RuboCop. The specs require 100% line coverage. These are the same checks the pipelines run:

```bash
bundle exec rubocop
bundle exec fasterer
bundle exec bundler-audit check --update
bundle exec brakeman --force-scan --quiet --no-pager --exit-on-warn --exit-on-error
bundle exec rspec
```

Fasterer reads `.fasterer.yml` and skips vendored gems, coverage, logs, tmp, and pkg.

## Continuous integration

A green pipeline has no build stage and no deploy stage. It means RuboCop, Fasterer, bundler-audit, Brakeman, and RSpec all passed. RSpec runs on Ruby 3.3, 3.4, and 4.0.6. The other jobs run on Ruby 4.0.6.

| Host | Workflow |
| --- | --- |
| GitHub | [`.github/workflows/ci.yml`](.github/workflows/ci.yml), on every push and pull request |
| GitLab tracker.webgate.pro | [`.gitlab-ci.yml`](.gitlab-ci.yml), on merge requests and on branch pipelines that do not already have an open merge request |

Both installs use Bundler 2.4.10 and a frozen `Gemfile.lock`.
