# entropia

* [VERSION 0.1.200114](https://github.com/carlosjhr64/entropia/releases)
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

    > irb -I ./lib 
    Welcome to IRB...
    >> require 'entropia' #=> true
    >> include ENTROPIA #=> Object
    >> e0 = E[8] #=> "10000101"
    >> e0.randomness #=> 0.0
    >> e0.entropy #=> 256
    >> e1 = E.new.pp(8,true){|n|rand(n)} #=> "11001101"
    >> e1.randomness #=> 8.0
    >> e1.entropy #=> 256
    >> e = e0+e1 #=> "1000010111001101"
    >> e.randomness #=> 8.0
    >> e.entropy #=> 65536
    >> e.shuffled? #=> false
    >> f = e.shuffle #=> "1011101110010000"
    >> f.shuffled? #=> true
    >> f.randomness #=> 8.0
    >> f.entropy #=> 65536
    >> H #=> 16
    >> fh = f*H #=> "BB90"
    >> Q #=> 91
    >> fq = f*Q #=> "(l^"
    >> W #=> 62
    >> fw = f*W #=> "CUS"
    >> # SHA512 digest...
    >   dfq = D[fq]
    => "\xE9z\e\xCC\x8F\... ...\xB4\xC0\xB6\xB5\xAC\xE4d"
    >> dfq.randomness #=> 8.0
    >> dfq.bits #=> 16.0
    >> dfq.length #=> 64
    >> dfq.entropy #=> 65536
    >> dfq*H
    => "3A7D6F323F36B7345973F6... ...5A665A605B5AD67264"

## INSTALL:

    > gem install entropia

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
