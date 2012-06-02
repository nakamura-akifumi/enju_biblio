$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "enju_biblio/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "enju_biblio"
  s.version     = EnjuBiblio::VERSION
  s.authors     = ["Kosuke Tanabe"]
  s.email       = ["tanabe@mwr.mediacom.keio.ac.jp"]
  s.homepage    = "https://github.com/nabeta/enju_circulation"
  s.summary     = "enju_circulation plugin"
  s.description = "Bibliographic record module for Next-L Enju"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", "~> 3.2"
  s.add_dependency "sunspot_rails", "~> 2.0.0.pre.120417"
  s.add_dependency "acts_as_list"
  s.add_dependency "paperclip"
  s.add_dependency "paperclip-meta"
  s.add_dependency "aws-sdk"
  s.add_dependency "marc"
  s.add_dependency "inherited_resources"
  s.add_dependency "attribute_normalizer", "~> 1.1"
  s.add_dependency "devise"
  s.add_dependency "cancan"
  s.add_dependency "paper_trail"
  s.add_dependency "will_paginate"
  s.add_dependency "configatron"
  s.add_dependency "state_machine"
  s.add_dependency "addressable"
  s.add_dependency "validates_timeliness"
  s.add_dependency "enju_oai"
  s.add_dependency "has_scope"
  s.add_dependency "enju_ndl"
  # s.add_dependency "jquery-rails"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "factory_girl_rails"
  s.add_development_dependency "vcr"
  s.add_development_dependency "fakeweb"
  s.add_development_dependency "sunspot_solr", "~> 2.0.0.pre.120417"
  s.add_development_dependency "enju_circulation"
  s.add_development_dependency "enju_inventory"
  s.add_development_dependency "enju_bookmark"
  s.add_development_dependency "enju_event"
end
