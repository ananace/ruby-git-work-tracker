# frozen_string_literal: true

require File.join File.expand_path('lib', __dir__), 'git_work_tracker/version'

Gem::Specification.new do |spec|
  spec.name          = 'git_work_tracker'
  spec.version       = GitWorkTracker::VERSION
  spec.authors       = ['Alexander Olofsson']
  spec.email         = ['ace@haxalot.com']

  spec.summary       = 'A ruby application for tracking your Git repos'
  spec.description   = "A ruby application that makes sure your code doesn't go stale, or end up unpushed"
  spec.homepage      = 'https://github.com/ananace/ruby-git_work_tracker'
  spec.license       = 'MIT'

  spec.extra_rdoc_files = %w[CHANGELOG.md LICENSE.md README.md]
  spec.files            = Dir['{bin,lib}/**/*'] + spec.extra_rdoc_files
  spec.executables      = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }

  spec.add_development_dependency 'mocha'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'test-unit'

  spec.add_dependency 'git'
  spec.add_dependency 'logging', '~> 2'
  spec.add_dependency 'thor'
end
