# entropia

* [VERSION 0.1.200122](https://github.com/carlosjhr64/entropia/releases)
* [github](https://www.github.com/carlosjhr64/entropia)
* [rubygems](https://rubygems.org/gems/entropia)

## DESCRIPTION:

Creates random strings with different base alphabets and
converts to and from.

Keeps track of the entropy content of the strings.
Keeps track of the number of bits that were randomly generated.
Keeps track of it's shuffled state.

## SYNOPSIS:

Note that Entropia subclases [BaseConvert](https://www.github.com/carlosjhr64/base_convert):

    $ irb -I ./lib 
    # Welcome to IRB...
    require 'entropia'
    include ENTROPIA

    RNG = Random.new(0)

    a = Entropia.new '0011', base: 2
    a.inspect #=> "0011 2:P95 0.0% -"
    a.to_i #=> 3

    e2 = Entropia.new 5, entropy:16, base: 2
    e2 #=> 0101 2:P95 0.0% -
    e2.to_s #=> "0101"

    e2.increment!(4)
    e2 #=> 00000101 2:P95 0.0% -
    e2.entropy #=> 256
    e2.bits #=> 8.0

    e8 = e2.to_base(8)
    e8 #=> 005 8:P95 0.0% -
    e8.length #=> 3
    e8.binary #=> "000000101"

    e8.shuffled? #=> false
    e8.randomness #=> 0.0

    f8 = e8.shuffle(RNG) #=> 030 8:P95 0.0% +
    f8.binary #=> "000011000"

    f8.randomize!(random: RNG) #=> 425 8:P95 100% -
    f8.randomness #=> 9.0

    g = f8*16
    g #=> 115 16:P95 75% -

    dg = g.digest
    dg #=> 764C8A3561C7CF261771B4E1969B84C210836F3C034BAEBAC5E49A394A6EE0A9 16:P95 3.5% +
    dg.bits #=> 256.0
    dg.randomness #=> 9.0
    # The 3.5% above on the inspect is the percent random value:
    dg.randomness / dg.bits #=> 0.03515625

    data = dg.data
    data.unpack1('H*') #=> 764c8a3561c7cf261771b4e1969b84c210836f3c034baebac5e49a394a6ee0a9

    key = Entropia.new 'Where does it rain?', base: 95
    code = Entropia.new 'Z*~RUwN=MuHCh ^*Nl#6FVNi7YsQ5xw<(gp', base: 95
    (key^code).to_s #=> "The rain rains mainly in the plain."

    a = E[60]{RNG}*64 #=> 9crl9m1RSa 64:P95 100% -
    b = E[60]{876858701620395078}*32 #=> OAPQAVI4MF26 32:P95 0.0% -
    a+b #=> 9crl9m1RSamhEbVaIpn6 64:P95 50% -

## INSTALL:

    $ gem install entropia

## KNOWN ISSUES:

Currently, Entropia naively adds randomness up...
this only works when adding independent sources.
Here are two cases where the calculations go wrong:

    a = E[60]{RNG}*64 #=> mhEbVaIpn6 64:P95 100% -
    a.randomness #=> 60.0
    aa = a+a #=> mhEbVaIpn6mhEbVaIpn6 64:P95 100% -
    aa.randomness #=> 120.0

    z = a^a #=> 0000000000 64:P95 100% -
    z.randomness #=> 60.0

Also, I made some perhaps arbitrary choices as to how shuffle state is preserved:

    a = E.new 'ABCDEFG', base: 95
    i = E.new '1234567', base: 95
    # shuffle the bits...
    as = a.shuffle(RNG) #=> Cu8T|Sa 95:P95 0.0% +
    is = i.shuffle(RNG) #=> 1)10qm! 95:P95 0.0% +
    # Concat negates shuffle state
    as+is #=> Cu8T|Sa1)10qm! 95:P95 0.0% -

## BETA TESTING:

Probably the best way to see the intended use of Entropia
is by following along my [beta testing page](BETA_TESTING.md) for the gem.

## LICENSE:

(The MIT License)

Copyright (c) 2020 CarlosJHR64

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
