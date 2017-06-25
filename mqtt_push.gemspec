# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mqtt_push/version'

Gem::Specification.new do |spec|
  spec.name          = "mqtt_push"
  spec.version       = MqttPush::VERSION
  spec.authors       = ["bestjane"]
  spec.email         = ["mr.bestjane@gmail.com"]

  spec.summary       = %q{mqtt 消息推送}
  spec.description   = %q{一个ruby的mqtt消息推送gem}
  spec.homepage      = "https://github.com/bestjane/mqtt_push"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
end
