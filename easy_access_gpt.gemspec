require_relative 'lib/easy_access_gpt/version'

Gem::Specification.new do |spec|
  spec.name = 'easy_access_gpt'
  spec.version = EasyAccessGpt::VERSION
  spec.authors = ['AnySiPlusplus']
  spec.email = ['denis1sorokin@gmail.com']

  spec.summary = ' Write a short summary, because RubyGems requires one.'
  spec.description = 'Write a longer description or delete this line.'
  spec.homepage = 'https://github.com/AnySiPlusplus'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 2.7.0'

  spec.metadata['allowed_push_host'] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/AnySiPlusplus'
  spec.metadata['changelog_uri'] = 'https://github.com/AnySiPlusplus'

  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) || f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor])
    end
  end

  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'fasterer', '~> 0.9.0'
  spec.add_development_dependency 'httparty', '~> 0.21.0'
  spec.add_development_dependency 'pry', '~> 0.14.1'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.11'
  spec.add_development_dependency 'rspec_junit_formatter', '~> 0.5.1'
  spec.add_development_dependency 'rubocop', '~> 1.25'
  spec.add_development_dependency 'rubocop-performance', '~> 1.13', '>= 1.13.2'
  spec.add_development_dependency 'rubocop-rake', '~> 0.6.0'
  spec.add_development_dependency 'rubocop-rspec', '~> 2.8'
  spec.add_development_dependency 'simplecov', '~> 0.21.2'
end
