# entropia

* [VERSION 0.1.200115](https://github.com/carlosjhr64/entropia/releases)
* [github](https://www.github.com/carlosjhr64/entropia)
* [rubygems](https://rubygems.org/gems/entropia)

## DESCRIPTION:

Creates random strings with different base alphabets and
converts to and from.

Convert random sequence of '0's and '1's to hexadecimal, for example.
Keeps track of the entropy content of the strings.
Keeps track of the number of bits that were randomly generated.
Keeps track of it's shuffled state.

## SYNOPSIS:

    $ irb -I ./lib 
    # Welcome to IRB...
    require 'entropia'
    include ENTROPIA

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

    e.randomize!(random: Random.new(0)) #=> 10101100 2:P95 100% -
    e.randomness #=> 8.0

    f = e.shuffle(random: Random.new(1))
    f #=> 01001101 2:P95 100% +
    # The '+' sign on the inspect above marks the "true" shuffle state.
    f.shuffled? #=> true

    g = f.to_base 16
    g #=> 4D 16:P95 100% +

    dg = g.sha2
    dg #=> 19DE495E14C9E7A2623EEEF6D2B7D84D0A14D4C202B34BEA0F29EA4650F4E137 16:P95 3.1% +
    dg.bits #=> 256.0
    dg.randomness #=> 8.0
    # The 3.1% above on the inspect is the percent random value:
    dg.randomness / dg.bits #=> 0.03125

    key = Entropia.new 'Where does it rain?', base: 95
    code = Entropia.new 'Z*~RUwN=MuHCh ^*Nl#6FVNi7YsQ5xw<(gp', base: 95
    (key^code).to_s #=> "The rain rains mainly in the plain."

## INSTALL:

    $ gem install entropia

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
