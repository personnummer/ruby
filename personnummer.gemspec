# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
    s.name        = 'personnummer'
    s.version     = '1.0.0'
    s.date        = '2017-10-21'
    s.summary     = 'Validate Swedish social security numbers'
    s.description = 'Validate Swedish social security numbers'
    s.authors     = ['Fredrik Forsmo']
    s.email       = 'fredrik.forsmo@gmail.com'
    s.files         = `git ls-files`.split("\n")
    s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
    s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
    s.require_paths = ["lib"]
    s.homepage    = 'https://github.com/personnummer/ruby'
    s.license     = 'MIT'
    s.add_development_dependency 'rake'
    s.add_development_dependency 'minitest'
  end