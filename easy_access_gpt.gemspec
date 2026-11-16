# frozen_string_literal: true

require_relative 'lib/easy_access_gpt/version'

Gem::Specification.new do |spec|
  spec.name = 'easy_access_gpt'
  spec.version = EasyAccessGpt::VERSION.identify
  spec.authors = %w[AnySiPlusplus sysadm WebgateSystems]
  spec.email = %w[denis1sorokin@gmail.com sladkowski@webgate.pro]

  spec.summary = 'Chat, translate, and moderate text through the OpenAI chat API.'
  spec.description = 'Ruby gem for chat, translation, and profanity checks via OpenAI chat completions. ' \
                     'Defaults to gpt-5.6-terra and requires Ruby 3.3 or newer.'
  spec.homepage = 'https://github.com/WebgateSystems/EasyAccessGPT'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.3.0'
  # Oldest Ruby the locked native gems install on. Keep .gitlab-ci.yml and .github/workflows/ci.yml in step.
  spec.metadata['supported_ruby_versions'] = '3.3, 3.4, 4.0'

  # spec.metadata['allowed_push_host'] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/WebgateSystems/EasyAccessGPT'
  spec.metadata['changelog_uri'] = 'https://github.com/WebgateSystems/EasyAccessGPT/blob/main/CHANGELOG.md'

  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) || f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor])
    end
  end

  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'benchmark', '~> 0.4'
  spec.add_development_dependency 'brakeman', '~> 8.0'
  spec.add_development_dependency 'bundler-audit', '~> 0.9.2'
  spec.add_development_dependency 'fasterer', '~> 0.9.0'
  spec.add_runtime_dependency 'httparty', '~> 0.24.0'
  # Former default libraries. Ruby 4 only loads them when the gem declares them.
  spec.add_runtime_dependency 'base64'
  spec.add_runtime_dependency 'bigdecimal'
  spec.add_runtime_dependency 'csv'
  spec.add_runtime_dependency 'rexml', '>= 3.3.9', '< 4'
  spec.add_development_dependency 'pry', '~> 0.16.0'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.11'
  spec.add_development_dependency 'rspec_junit_formatter', '~> 0.5.1'
  spec.add_development_dependency 'rubocop', '~> 1.25'
  spec.add_development_dependency 'rubocop-performance', '~> 1.13', '>= 1.13.2'
  spec.add_development_dependency 'rubocop-rake', '~> 0.6.0'
  spec.add_development_dependency 'rubocop-rspec', '~> 2.8'
  spec.add_development_dependency 'simplecov', '~> 0.21.2'
end
