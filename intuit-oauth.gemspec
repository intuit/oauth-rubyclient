# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.add_dependency 'httparty', '~> 0.16.3'
  spec.add_dependency 'json', '~> 2.1'
  spec.add_dependency 'rsa-pem-from-mod-exp', '~> 0.1.0'

  spec.authors       = ['Intuit Inc']
  spec.description   = 'A Ruby wrapper Intuit\'s OAuth and OpenID implementation.'
  spec.email         = ['idgsdk@intuit.com']
  spec.homepage      = 'https://github.com/intuit/oauth-rubyclient'
  spec.licenses      = ['Apache-2.0']
  spec.name          = 'intuit-oauth'
  spec.required_ruby_version = '>= 1.9.0'
  spec.required_rubygems_version = '>= 1.3.5'
  spec.summary       = 'A Ruby wrapper for the OAuth 2.0 protocol.'
  spec.version       = '1.0.0'

  spec.require_paths = %w[lib]
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(bin|test|spec|features)/})
  end

  spec.add_development_dependency 'addressable', '~> 2.3'
  spec.add_development_dependency 'backports', '~> 3.11'
  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'coveralls', '~> 0.8'
  spec.add_development_dependency 'rake', '~> 11.0'
  spec.add_development_dependency 'rdoc', ['>= 5.0', '< 7']
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'wwtd', '~> 0'
end
