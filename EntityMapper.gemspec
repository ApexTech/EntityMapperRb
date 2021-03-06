require_relative 'lib/EntityMapper/version'

Gem::Specification.new do |spec|
  spec.name          = "EntityMapper"
  spec.version       = EntityMapper::VERSION
  spec.authors       = ["Marcos Mercedes"]
  spec.email         = ["marcos.mercedesn@gmail.com"]

  spec.summary       = %q{Maps and serializes object representations}
  spec.description   = %q{Provides an easy interface for creating object from JSON responses, also serializes selected properties from those objects into json}
  spec.homepage      = ""
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["homepage_uri"] = "http://github.com/ApexTech/EntityMapper"
  spec.metadata["source_code_uri"] = "http://github.com/ApexTech/EntityMapper"
  spec.metadata["changelog_uri"] = "http://github.com/ApexTech/EntityMapper/README.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
