Gem::Specification.new do |s|

  s.name     = 'entropia'
  s.version  = '0.1.200102'

  s.homepage = 'https://github.com/carlosjhr64/entropia'

  s.author   = 'carlosjhr64'
  s.email    = 'carlosjhr64@gmail.com'

  s.date     = '2020-01-02'
  s.licenses = ['MIT']

  s.description = <<DESCRIPTION
Creates random strings with different base alphabets and
converts to and from.

Convert random sequence of '0's and '1's to hexadecimal, for example.
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
ANALYSIS.txt
README.md
lib/entropia.rb
lib/entropia/digest.rb
lib/entropia/entropia.rb
  )

  s.add_runtime_dependency 'base_convert', '~> 3.1', '>= 3.1.191231'
  s.requirements << 'ruby: ruby 2.7.0p0 (2019-12-25 revision 647ee6f091) [x86_64-linux]'

end
