# EasyAccessGpt

Welcome, the 'Easy access gpt' gem is designed to easily enable gpt chat, translate text using gpt chat, and check content for obscene language.

## Installation

Install the gem and add to the application's Gemfile by executing:

```bash
gem 'easy_access_gpt', git: 'https://github.com/WebgateSystems/EasyAccessGPT.git', branch: 'develop'
```
Run the bundle command to install it.


## Initial setup with Rails:

To set the default Api key, create a initializer in <tt>config/initializers/easy_access_gpt.rb</tt>:

``` ruby
EasyAccessGpt::Configure.api_key = 'your api key'
```


There is also a chat search model setting gpt

``` ruby
EasyAccessGpt::Configure.gpt_model = 'default value:  gpt-3.5-turbo'
```

And changing the locales to which the text needs to be translated:

``` ruby
EasyAccessGpt::Configure.available_locales = 'default values:  [en pl fr ua de ru es it]'
```

## Initial setup without Rails:

```bash
require_relative 'lib/easy_access_gpt'

EasyAccessGpt::Configure.api_key = 'your api key'
EasyAccessGpt::Configure.gpt_model = 'default value:  gpt-3.5-turbo'
EasyAccessGpt::Configure.available_locales = 'default values:  [en pl fr ua de ru es it]'
```

## Usage

### For normal chat use just call the command:

``` ruby
EasyAccessGpt::Communication.new('your message').call
```
Usage excample: 

``` ruby
request: EasyAccessGpt::Communication.new('hello').call

response: 'Hello! How can I assist you today?'
```

### To use gems to translate text:

Run command: 

``` ruby
EasyAccessGpt::Translation.new({body: 'your message'}).call
```

Usage excample: 

``` ruby
request: EasyAccessGpt::Translation.new({body: 'hello'}).call

response: {"en"=>{"body"=>"hello"},
           "pl"=>{"body"=>"cześć"},
           "fr"=>{"body"=>"bonjour"},
           "ua"=>{"body"=>"привіт"},
           "de"=>{"body"=>"hallo"},
           "ru"=>{"body"=>"привет"},
           "es"=>{"body"=>"hola"},
           "it"=>{"body"=>"ciao"}}
```

### Using Gems to check text for offensive content

Run command: 

``` ruby
EasyAccessGpt::Filter.new({body: 'your message'}).call
```

Usage excample: 

``` ruby
request: EasyAccessGpt::Translation.new('hello').call

response: {"message_include_profanity"=>false}
```

```bash
request: EasyAccessGpt::Translation.new('text include bad words').call

response: {"message_include_profanity"=>true}
```

