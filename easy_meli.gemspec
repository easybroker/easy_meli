
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "easy_meli/version"

Gem::Specification.new do |spec|
  spec.name          = "easy_meli"
  spec.version       = EasyMeli::VERSION
  spec.authors       = ["Eric Northam"]
  spec.email         = ["eric@northam.us"]

  spec.summary       = %q{A simple gem to work with MercadoLibre's API}
  spec.homepage      = "https://github.com/easybroker/easy_meli"
  spec.license       = "MIT"

  if spec.respond_to?(:metadata)
    spec.metadata["homepage_uri"] = spec.homepage
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "httparty", "~> 0.21"
  spec.add_dependency "rexml", "~> 3.3.9"
  spec.add_dependency "multi_xml", "~> 0.6.0"

  spec.add_development_dependency "bundler", "~> 2.3.6"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "minitest", "~> 5.18"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "webmock"
  spec.add_development_dependency "mocha"
end
