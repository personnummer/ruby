# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
    s.name        = 'personnummer'
    s.version     = '3.1.0'
    s.date        = '2026-11-13'
    s.summary     = 'Validate Swedish social security numbers'
    s.description = 'Validate Swedish social security numbers'
    s.authors     = ['Jack Millard']
    s.email       = ['millard64@hotmail.co.uk']
    s.files         = `git ls-files`.split("\n")
    s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
    s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
    s.require_paths = ["lib"]
    s.homepage    = 'https://github.com/personnummer/ruby'
    s.license     = 'MIT'
    # The oldest Ruby in the CI matrix.
    s.required_ruby_version = '>= 3.3'
    s.add_development_dependency 'rake'
    s.add_development_dependency 'minitest'
    s.add_development_dependency 'timecop'
  end
