lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "on_ramp/version"

Gem::Specification.new do |spec|
  spec.name          = "on_ramp"
  spec.version       = OnRamp::VERSION
  spec.authors       = ["Michael Sterling", "Rhoen Pruesse-Adams", "James Lee"]
  spec.email         = ["michael@teachable.com", "rhoen@teachable.com", "james@teachable.com"]

  spec.summary       = "An internal Teachable library for ramping up experiments incrementally and segmenting users in A/B tests"


  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|experiments)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # development dependencies
  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "byebug"
  spec.add_development_dependency "gem-release"
end
