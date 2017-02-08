Gem::Specification.new do |spec|
  spec.name           = "roda-mailer_ext"
  spec.version        = "0.1.0"
  spec.authors        = ["Adam Daniels"]
  spec.email          = "adam@mediadrive.ca"

  spec.summary        = %q()
  spec.description    = %q()

  spec.homepage       = "https://github.com/adam12/roda-mailer_ext"
  spec.license        = "MIT"

  spec.files          = Dir["lib/**/*.rb"]
  spec.require_paths  = ["lib"]

  spec.add_dependency "roda", ">= 2.0.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
