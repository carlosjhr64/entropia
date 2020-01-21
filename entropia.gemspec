Gem::Specification.new do |s|

  s.name     = 'entropia'
  s.version  = '0.1.200121'

  s.homepage = 'https://github.com/carlosjhr64/entropia'

  s.author   = 'carlosjhr64'
  s.email    = 'carlosjhr64@gmail.com'

  s.date     = '2020-01-21'
  s.licenses = ['MIT']

  s.description = <<DESCRIPTION
Creates random strings with different base alphabets and
converts to and from.

Keeps track of the entropy content of the strings.
Keeps track of the number of bits that were randomly generated.
Keeps track of it's shuffled state.
DESCRIPTION

  s.summary = <<SUMMARY
Creates random strings with different base alphabets and
converts to and from.
SUMMARY

  s.require_paths = ['lib']
  s.files = %w(
BETA_TESTING.md
README.md
lib/entropia.rb
lib/entropia/digest.rb
lib/entropia/entropia.rb
lib/entropia/terse.rb
  )

  s.add_runtime_dependency 'base_convert', '~> 4.0', '>= 4.0.200111'
  s.requirements << 'ruby: ruby 2.7.0p0 (2019-12-25 revision 647ee6f091) [x86_64-linux]'

end
