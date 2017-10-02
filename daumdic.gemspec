# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name        = 'daumdic'
  s.version     = '1.0.0'
  s.date        = '2017-10-02'
  s.licenses    = ['Apache-2.0', 'MIT']
  s.summary     = 'Daum Dictionary'
  s.description = 'Daum Dictionary API written in ruby.'
  s.authors     = ['Hyeon Kim']
  s.email       = 'simnalamburt@gmail.com'
  s.files       = ['lib/daumdic.rb']
  s.homepage    = 'https://github.com/simnalamburt/daumdic-ruby'

  s.add_runtime_dependency 'nokogiri', '~> 1.8'
end
