Gem::Specification.new do |s|
  s.name        = 'boletorb'
  s.version     = '0.0.1'
  s.date        = '2010-04-23'
  s.summary     = "Boleto RB"
  s.description = "A gem for generating brazilian 'boletos'"
  s.authors     = ["Filipe Monteiro"]
  s.email       = 'filipe@tfsolutions.com.br'
  s.files       = [
                    "Gemfile",
                    "Gemfile.lock",
                    "boletorb.gemspec",
                    "lib/boletorb.rb", 
                    "lib/boletorb/santander.rb"]
  s.homepage    = 'http://rubygems.org/gems/boletorb'
  s.license     = 'MIT'

  #dependencies
  s.add_dependency 'thinreports', '0.7.7'
  s.add_dependency 'barby', '0.5.1'
  s.add_dependency 'chunky_png', '1.3.1'

  #s.add_development_dependency "rspec", '~> 0'

  s.require_paths = ["lib"]
end