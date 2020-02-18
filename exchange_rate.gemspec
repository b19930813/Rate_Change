require_relative 'lib/exchange_rate/version'

Gem::Specification.new do |spec|
  spec.name          = "exchange_rate_TW"
  spec.version       = ExchangeRate::VERSION
  spec.authors       = ["Frank Tseng"]
  spec.email         = ["b19930813@gmail.com"]

  spec.summary       = %q{Get exchange rate.}
  spec.description   = %q{Get exchange rate from ESun , Taiwan bank}
  spec.homepage      = "https://github.com/b19930813/Rate_Change"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  #spec.metadata["allowed_push_host"] = "'http://mygemserver.com'"

  #spec.metadata["homepage_uri"] = spec.homepage
  #spec.metadata["source_code_uri"] = "https://github.com/b19930813/Rate_Change"
  #spec.metadata["changelog_uri"] = "https://github.com/b19930813/Rate_Change"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
