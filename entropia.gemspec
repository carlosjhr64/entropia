Gem::Specification.new do |s|

  s.name     = 'entropia'
  s.version  = '0.1.191226'

  s.homepage = 'https://github.com/carlosjhr64/entropia'

  s.author   = 'CarlosJHR64'
  s.email    = 'carlosjhr64@gmail.com'

  s.date     = '2019-12-26'
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

  s.extra_rdoc_files = ['README.rdoc']
  s.rdoc_options     = ["--main", "README.rdoc"]

  s.require_paths = ["lib"]
  s.files = %w(
ANALYSIS.txt
History.txt
README.rdoc
TODO.txt
lib/entropia.rb
lib/entropia/digest.rb
lib/entropia/entropia.rb
lib/entropia/lb.rb
lib/entropia/version.rb
test/test_digest.rb
test/test_entropia.rb
test/test_lb.rb
  )

  s.add_runtime_dependency 'base_convert', '~> 0.0', '>= 0.0.1'
  s.add_development_dependency 'test-unit', '~> 2.5', '>= 2.5.5'
  s.requirements << 'ruby: ruby 2.1.0p0 (2013-12-25 revision 44422) [x86_64-linux]'

end
