require 'puppetlabs_spec_helper/module_spec_helper'
require 'rspec-puppet-facts'

begin
  require 'spec_helper_local' if File.file?(File.join(File.dirname(__FILE__), 'spec_helper_local.rb'))
rescue LoadError => loaderror
  warn "Could not require spec_helper_local: #{loaderror.message}"
end

include RspecPuppetFacts

default_facts = {
  puppetversion: Puppet.version,
  facterversion: Facter.version,
}

default_facts_path = File.expand_path(File.join(File.dirname(__FILE__), 'default_facts.yml'))
default_module_facts_path = File.expand_path(File.join(File.dirname(__FILE__), 'default_module_facts.yml'))

if File.exist?(default_facts_path) && File.readable?(default_facts_path)
  default_facts.merge!(YAML.safe_load(File.read(default_facts_path)))
end

if File.exist?(default_module_facts_path) && File.readable?(default_module_facts_path)
  default_facts.merge!(YAML.safe_load(File.read(default_module_facts_path)))
end

RSpec.configure do |c|
  c.default_facts = default_facts
end

dir = File.expand_path(File.dirname(__FILE__))
$LOAD_PATH.unshift File.join(dir, 'lib')

# So everyone else doesn't have to include this base constant.
module PuppetSpec
  FIXTURE_DIR = File.join(File.expand_path(File.dirname(__FILE__)), "fixtures") unless defined?(FIXTURE_DIR)
end

require 'puppet_spec/files'

Pathname.glob("#{dir}/shared_behaviours/**/*.rb") do |behaviour|
  require behaviour.relative_path_from(Pathname.new(dir))
end
