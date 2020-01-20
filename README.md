# entropia

* [VERSION 0.1.200120](https://github.com/carlosjhr64/entropia/releases)
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

    e = Entropia.new '00000000', base: 2
    e #=> 00000000 2:P95 0.0% -
    e.inspect #=> "00000000 2:P95 0.0% -"
    e.to_i #=> 0
    e.to_s #=> "00000000"
    e.length #=> 8
    e.entropy #=> 256
    e.bits #=> 8.0
    e.binary #=> "00000000"

    e.shuffled? #=> false
    e.randomness #=> 0.0

    e.randomize!(random: RNG) #=> 10101100 2:P95 100% -
    e.randomness #=> 8.0

    f = e.shuffle(random: RNG)
    f #=> 01010110 2:P95 100% +
    # The '+' sign on the inspect above marks the "true" shuffle state.
    f.shuffled? #=> true

    g = f.to_base 16
    g #=> 56 16:P95 100% +

    dg = g.sha2
    dg #=> 7688B6EF52555962D008FFF894223582C484517CEA7DA49EE67800ADC7FC8866 16:P95 3.1% +
    dg.bits #=> 256.0
    dg.randomness #=> 8.0
    # The 3.1% above on the inspect is the percent random value:
    dg.randomness / dg.bits #=> 0.03125

    key = Entropia.new 'Where does it rain?', base: 95
    code = Entropia.new 'Z*~RUwN=MuHCh ^*Nl#6FVNi7YsQ5xw<(gp', base: 95
    (key^code).to_s #=> "The rain rains mainly in the plain."

## INSTALL:

    $ gem install entropia

## KNOWN ISSUES:

Currently, Entropia naively adds randomness up...
this only works when adding independent sources.
Here are two cases where the calculations go wrong.

    a = E[60]{RNG}*64 #=> LPKHLYPjRo 64:P95 100% -
    a.randomness #=> 60.0
    aa = a+a #=> LPKHLYPjRoLPKHLYPjRo 64:P95 100% -
    aa.randomness #=> 120.0

    z = a^a #=> 0000000000 64:P95 100% -
    z.randomness #=> 60.0

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
