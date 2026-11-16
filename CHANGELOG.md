## [Unreleased]

## [0.3.0] - 2026-11-16

- Require Ruby 3.2 or newer. Ruby 3.1 and older cannot install the patched dependencies, so those versions are no longer tested.
- Update httparty, rexml, activesupport, addressable, concurrent-ruby, faraday, and faraday-http-cache past the versions reported by bundler-audit.
- Load on Ruby 4.0, where Pry 0.14 and several former default libraries no longer resolve on their own.
- Call OpenAI with gpt-5.6-terra and the chat parameters that model accepts.

## [0.1.0] - 2023-07-31

- Initial release
