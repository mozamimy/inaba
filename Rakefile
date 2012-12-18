require "rake/gempackagetask"

spec = Gem::Specification.new do |s|
  s.name         = "inaba"
  s.summary      = "Inaba SDBM Manipulator is a command line tool to manipulate SDBM database."
  s.description  = File.read(File.join(File.dirname(__FILE__), "README.md"))
  s.version      = "0.0.2"
  s.author       = "Moza USANE"
  s.email        = "mozamimy@quellencode.org"
  s.homepage     = "http://quellencode.org/"
  s.platform     = Gem::Platform::RUBY
  s.required_ruby_version = ">=1.9"
  s.add_dependency "hakto", ">=0.0.1"
  s.add_dependency "ariete", ">=0.0.1"
  s.executables  = ["inaba"]
  s.files        = Dir["**/**"]
  s.test_files   = Dir["test/tb_*.rb"]
  s.has_rdoc     = true
end

Rake::GemPackageTask.new(spec).define
