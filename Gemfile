source ENV['GEM_SOURCE'] || "https://rubygems.org"

def location_for(place, fake_version = nil)
  if place =~ /^(git[:@][^#]*)#(.*)/
    [fake_version, { :git => $1, :branch => $2, :require => false }].compact
  elsif place =~ /^file:\/\/(.*)/
    ['>= 0', { :path => File.expand_path($1), :require => false }]
  else
    [place, { :require => false }]
  end
end

# C Ruby (MRI) or Rubinius, but NOT Windows
platforms :ruby do
  gem 'pry', :group => :development
  gem 'yard', :group => :development
  gem 'redcarpet', '~> 2.0', :group => :development
  gem "racc", "1.4.16", :group => :development

  # To enable the augeas feature, use this gem.
  # Note that it is a native gem, so the augeas headers/libs
  # are neeed.
  #gem 'ruby-augeas', :group => :development
end

if !ENV['PUPPET_LOADED']
  gem "puppet", :path => File.dirname(__FILE__), :require => false
end
gem "facter", '2.5.7'
gem "hiera", '1.3.4'
gem "rake", "12.3.3", :require => false
gem "syck", '1.4.0'
gem "sync", '0.5.0'
gem "scanf", '1.0.0'

group(:development, :test) do
  gem "rspec", "~> 3.9.0", :require => false
  gem "mocha", :require => false
  gem "yarjuf", "~> 1.0"
  gem "xmlrpc"
  gem "net-telnet"

  # json-schema does not support windows, so omit it from the platforms list
  # json-schema uses multi_json, but chokes with multi_json 1.7.9, so prefer 1.7.7
  gem "multi_json", "1.7.7", :require => false, :platforms => [:ruby, :jruby]
  gem "json-schema", "2.1.1", :require => false, :platforms => [:ruby, :jruby]
end

group(:development) do
  if RUBY_PLATFORM != 'java'
    case RUBY_VERSION
    when /^1.8/
      gem 'ruby-prof', "~> 0.13.1", :require => false
    else
      gem 'ruby-prof', :require => false
    end
  end
end

group(:extra) do
  gem "rack", "~> 1.6", :require => false
  gem "activerecord", :require => false
  gem "i18n", :require => false
  gem "couchrest", :require => false
  gem "net-ssh", '~> 4.2.0', :require => false
  gem "puppetlabs_spec_helper", '2.15', :require => false
  # rest-client is used only by couchrest, so when
  # that dependency goes away, this one can also
  gem "rest-client", :require => false
  gem "stomp", :require => false
  gem "tzinfo", :require => false
  case RUBY_PLATFORM
  when 'java'
    gem "jdbc-sqlite3", :require => false
    gem "msgpack-jruby", :require => false
  else
    gem "sqlite3", :require => false
    gem "msgpack", :require => false
  end
end

require 'yaml'
data = YAML.load_file(File.join(File.dirname(__FILE__), 'ext', 'project_data.yaml'))
bundle_platforms = data['bundle_platforms']
x64_platform = Gem::Platform.local.cpu == 'x64'
data['gem_platform_dependencies'].each_pair do |gem_platform, info|
  next if gem_platform == 'x86-mingw32' && x64_platform
  next if gem_platform == 'x64-mingw32' && !x64_platform
  if bundle_deps = info['gem_runtime_dependencies']
    bundle_platform = bundle_platforms[gem_platform] or raise "Missing bundle_platform"
    platform(bundle_platform.intern) do
      bundle_deps.each_pair do |name, version|
        gem(name, version, :require => false)
      end
    end
  end
end

if File.exists? "#{__FILE__}.local"
  eval(File.read("#{__FILE__}.local"), binding)
end

# vim:filetype=ruby
