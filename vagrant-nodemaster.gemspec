# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'vagrant-nodemaster/version'

Gem::Specification.new do |spec|
  spec.name          = "vagrant-nodemaster"
  spec.version       = Vagrant::NodeMaster::VERSION
  spec.authors       = ["Francisco Javier Lopez de San Pedro"]
  spec.email         = ["fjsanpedro@gmail.com"]
  spec.description   = "This Vagrant plugin allows you to control centralizely remote virtual environments configured with vagrant-node."

  spec.summary       = "This plugin allows you to control centralizely remote virtual environments configured with the plugin Vagrant-Node(https://github.com/fjsanpedro/vagrant-nodemaster/tree/master/lib/vagrant-node).


This plugin has been developed in the context of the Catedra SAES of the University of Murcia(Spain)."

  spec.homepage      = "http://www.catedrasaes.org"
  spec.license       = "GNU"


  spec.rubyforge_project = "vagrant-nodemaster"

  spec.add_dependency "rest-client"
  spec.add_dependency "sqlite3"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
