# ENTROPIA

## Entropy

What is Entropy?
In the Ruby gem, Entropia,
entropy is:

* The number of possible arrangements a String can have.

With a character set of only two characters, "01", then
a String of length four has an entropy of 16...
sixteen possible arrangements:

1.  "0000"
2.  "0001"
3.  "0010"
4.  "0011"
5.  "0100"
6.  "0101"
7.  "0110"
8.  "0111"
9.  "1000"
10. "1001"
11. "1010"
12. "1011"
13. "1100"
14. "1101"
15. "1110"
16. "1111"

## Entropia gem

I'll use the Entropia gem to write the mathetical notation:

    require 'entropia'
    include ENTROPIA

    n = Entropia.new '0123', base: 10
    n.to_i       #=> 123
    n.to_s       #=> "0123"
    n.base       #=> 10
    n.entropy    #=> 10000
    n.bits       #=> 13.28771237954945
    n.randomness #=> 0.0
    n.digits
    #=> 0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz!?$&@*+-/<=>^~,.:;|#\()[]{}%"'`_ 

    # Entropia#inspect #=> "<string> <base>:<digits key> <percent random>% <+/- (shuffled?)>"
    n.inspect #=> 0123 10:P95 0.0% -

    BaseConvert::DIGITS[:P95]
    #=> 0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz!?$&@*+-/<=>^~,.:;|#\()[]{}%"'`_ 

The Entropia gem subclasses the
[BaseConvert gem](https://github.com/carlosjhr64/base_convert).

## Bits

A bit of information is knowlege of something that could be found in one of two ways...
true or false...  "1" or "0".
For 4 bits of entropy I write:

    e = E[4]
    e         #=> 0000
    e.entropy #=> 16
    e.bits    #=> 4.0

Entropy and bits are related by any one of these equations:

    e.entropy == 2 ** e.bits         #=> true
    Math.log(e.entropy, 2) == e.bits #=> true
    Lb[e.entropy] == e.bits          #=> true
    
`Lb` is the log base 2 function and returns a Float, which
is why bits is shown as a Float and not an Integer... and
in general bits are not guaranteed to be Integers.

    e = Entropia.new 'ZY', base: 3, digits: 'XYZ'
    e         #=> ZY
    e.entropy #=> 9
    e.bits    #=> 3.1699250014423126

I'll be saying that base 3 and base 2 are not commensurable, and
I'll show that conversion into a non-commensurable base
results in a String of greater entropy.

    e         #=> ZY
    e.entropy #=> 9
    e.to_base(2, '01')         #=> 0111
    e.to_base(2, '01').entropy #=> 16

## Randomness

The sense of entropy as a measure of randomness comes from the case when
one does not know which one of the many possible arrangements the String is in.
Entropia distinguishes and keeps track of the capacity of a String, entropy, and
the number of unknown bits, randomness.
 
Here is a "let's pretend" random string out of many possible:

    RNG = Random.new(0)
    string = 4.times.inject(''){|s,i| s << RNG.random_number(2).to_s}
    string #=> "0110"

By default, `E[n]` gives the zero valued binary String of length `n`:

    e = E[4] #=> 0000

I can get at random four bits:

    e = E[4]{RNG}
    e            #=> 0011
    e.entropy    #=> 16
    e.bits       #=> 4.0
    e.randomness #=> 4.0

By peeking, I can see that String happens to be "1111".
But it could gone any of 16 ways.
Without peeking every one of the 4 bits are not known, and
thus Entropia gives a randomness value of 4.0.

As an example, say the four bits in `a` are known,
while the four bits in `b` are not known...
I can concat the Strings:

    a = E[4]      #=> 0000
    b = E[4]{RNG} #=> 1011
    c = a+b       #=> 00001011
    c.length      #=> 8
    c.entropy     #=> 256
    c.bits        #=> 8.0
    c.randomness  #=> 4.0

## Really big and small numbers

I'll be working with very big and small numbers.
I'll use the following constants in MKS units to scale out quantities:

    GHz = 1e9 # Gigaherts
    YEARS = 60*60*24*365.25 # seconds/year
    MILLION = 1e6
    BILLION = 1e9
    TRILLION = 1e12
    AGE_OF_UNIVERSE = 4.36e17
    PLANCK_TIME = 5.39e-44 # seconds

## Passwords

The entropy of a String is important in passwords.
According to Wikipedia's
[Paswords strength](http://en.wikipedia.org/wiki/Password_strength)
article:

> Due to currently understood limitations from fundamental physics,
> there is no expectation that any digital computer (or combination)
> will be capable of breaking 256-bit encryption via a brute-force attack.

Let's look at this claim with some quick numbers and
[Planck time](http://en.wikipedia.org/wiki/Planck_time).
Consider a hacker computer capable of testing one possible String at every Planck time interval.
The total time needed to review all possible 256 bit Strings is:

    bits = 256
    entropy = 2**bits
    total_time = PLANCK_TIME * entropy
    total_time #=> 6.241193609891342e+33
    total_time / (BILLION * YEARS) #=> 1.9777149117459318e+17
    total_time / AGE_OF_UNIVERSE #=> 1.4314664242870052e+16

It's just not possible to guess at a 256 bit password.
One can get a sense of how long a 256 bit password is:

    # Entropia.length(entropy Integer, base Integer) #=> Integer

    # For general ASCII(base 256)
    ascii = 256/Lb[256]
    ascii.round(1)        #=> 32.0
    E.length(2**256, 256) #=> 32

    # For graph(base 94)
    graph = 256/Lb[94]
    graph.round(1)       #=> 39.1
    E.length(2**256, 94) #=> 40

    # For alpha-numeric(base 62)
    alnum = 256/Lb[62]
    alnum.round(1)       #=> 43.0
    E.length(2**256, 62) #=> 43

    # For decimal digits(base 10):
    dec = 256/Lb[10]
    dec.round(1)         #=> 77.1
    E.length(2**256, 10) #=> 78

So what can this "Planck time" computer crack in the age of the Universe?

    entropy = AGE_OF_UNIVERSE / PLANCK_TIME
    bits = Lb[entropy]
    bits.round(1) #=> 202.3
    # For graph passwords
    E.length(entropy, 94) #=> 31

And in say two years?

    total_time = 2 * YEARS
    entropy = total_time / PLANCK_TIME
    bits = Lb[entropy]
    bits.round(1) #=> 169.6
    # For graph passwords
    E.length(entropy, 94) #=> 26

So it could crack a 170 bit password in just about a year on average.
We can get a sense of how long a 170 bit password is:

    # For general ASCII(base 256)
    ascii = 170/Lb[256]
    ascii.round(1)        #=> 21.3
    E.length(2**170, 256) #=> 22

    # For graph(base 94)
    graph = 170/Lb[94]
    graph.round(1)       #=> 25.9
    E.length(2**170, 94) #=> 26

    # For alpha-numeric(base 62)
    alnum = 170/Lb[62]
    alnum.round(1)       #=> 28.6
    E.length(2**170, 62) #=> 29

    # For decimal digits(base 10):
    dec = 170/Lb[10]
    dec.round(1)         #=> 51.2
    E.length(2**170, 10) #=> 52

What these password might look like:

    # Planck time computer impossible to crack
    e256 = E[256]{RNG}.to_base 94, :graph
    e256.length #=> 40
    e256.to_s
    #=> !c7ZF:]yhy1I`j&+Wq-R`p)KZZuw1>3mmU/o_h"N

    # Planck time computer cracked over cosmological time
    e202 = E[202]{RNG}.to_base 94, :graph
    e202.length #=> 31
    e202.to_s
    #=> #mT?<tf<Cg&x1lti(C8vPNUb3ydHD"%

    # Planck time computer cracked in within 2 years
    e170 = E[170]{RNG}.to_base 94, :graph
    e170.length #=> 26
    e170.to_s
    #=> FqhfVnXSBJal7:[7_*R?T\u4xX

All three of these passwords are somewhat easily typed on a single line, but
go from just impossible to crack to maybe cracked in a year.

Now, no real digital computer will ever be as fast as this "Planck time" computer.
What can a real computer do?
A quick google search(year today 2020) gave me about [320 billion passwords per second](
https://arstechnica.com/information-technology/2012/12/25-gpu-cluster-cracks-every-standard-windows-password-in-6-hours/).
And then there's the [Bitcoin hash rate...](https://www.blockchain.com/en/charts/hash-rate)
it peaked above 120 million tera-hashes.

    # At 320 Billion / Second
    total_time = 2 * YEARS
    entropy = total_time * 320 * BILLION
    bits = Lb[entropy]
    bits.round(1)               #=> 64.1
    Entropia.length entropy, 94 #=> 10

    # At 120 Million Trillion / Second
    total_time = 2 * YEARS
    entropy = total_time * 120 * MILLION * TRILLION
    bits = Lb[entropy]
    bits.round(1)               #=> 92.6
    Entropia.length entropy, 94 #=> 15

So if you're worried about the Bitcoin network cracking your password,
maybe you should use graph passwords of length 16, and
changed them at least once a year... :))

A graph password of length 16 might look like this:

    graph = Entropia.new RNG.random_number(94**16), base: 94, digits: :graph
    graph.length #=> 16
    graph        #=> &#Ab@>I=?dLK?H}6

## 256 bits

256 bits of entropy is a nice round number for computers.

    256 == 2**8              #=> true
    256 == 4**4              #=> true
    256 == 16**2             #=> true
    256 == 'FF'.to_i(16) + 1 #=> true

So lets get 256 bits of entropy:

    e = E[256]{RNG}
    e.length #=> 256

That's a long string!  256 zeroes and ones...
The string could be more manageable if expressed in hexadecimal notation.
Entropia makes conversion to other bases easy with the `*` operator:

    H #=> 16
    eh = e*H
    #=> A5EE9794052D08735E4513D0D52692F3F5081EC5C73547FE23EE074FDEB91DAF
    eh.length #=> 64

Hexadecimal is commensurable with 256 bits:
    
    2**256 == 16**64 #=> true

While the string reprectation of `eh` differs from `e`,
`eh` and `e` reprepreset the same entropy:

    eh.to_s == e.to_s #=> false
    # Nonetheless...
    eh == e
    #=> true
    # equivalent to
    eh.to_i       == e.to_i        and
    eh.entropy    == e.entropy     and
    eh.randomness == e.randomness  and
    eh.shuffled?  == e.shuffled?
    #=> true

Just to show that this is reversible:

    # Convert eh bach to base 2:
    e2 = eh*2
    # Note e2 and e are not the same object:
    e2.equal? e #=> false
    # But their Strings are equal:
    e2.to_s == e.to_s #=> true
    # and represent the same entropy:
    e2 == e #=> true

## Commensurability

Now, 256 bits is not commensarable with base 64:

    Math.log(2**256, 64) #=> 42.66666666666667
    E.length(2**256, 64) #=> 43
    2**256 == 64**43     #=> false

I can get the Integer representation in base 64, but
it will not be the same entropy:

    # Can use e or eh for this
    (e*64) == (eh*64)       #=> true
    e64 = e*64
    e64 #=> ANkbvG5BGXpNaKJqDKcalFr21x5npL7?YFk1q?UkHsl 64:P95 99% -
    e64.to_i == e.to_i      #=> true
    e64 == e                #=> false
    e64.entropy > e.entropy #=> true

To illustrate what's going on, I'll convert e64 back to base 16 and
show its string... it'll have a leading zero:

    e64*16
    #=> 0A5EE9794052D08735E4513D0D52692F3F5081EC5C73547FE23EE074FDEB91DAF
    # compare to
    eh
    #=> A5EE9794052D08735E4513D0D52692F3F5081EC5C73547FE23EE074FDEB91DAF

Entropia provides a method to test for commensurability:

    E.commensurable? 2**256, 2  #=> true
    E.commensurable? 2**256, 16 #=> true
    E.commensurable? 2**256, 64 #=> false

    eh
    #=> A5EE9794052D08735E4513D0D52692F3F5081EC5C73547FE23EE074FDEB91DAF 16:P95 100% -
    eh.commensurable? 64 #=> false

So now that we understand how base and length relate to the entropy of a string,
I can show why base 2 and base 3 can never mix:

    # In general: entropy = base**length
    # Just test m and n upto 10...
    a = [1,2,3,4,5,6,7,8,9,10]
    a.product(a).any?{|n,m| 2**n == 3**m} #=> false

As 2 and 3 are primes, any powers of 2 and 3 can not equal eachother.

So what entropies are commesurable in base 16 and base 64?
I will show that for any positive Integer `i>0`,
entropies `16**n` and `65**m` will work when `m=2*i` and `n=3*i`.
To get irb to follow along,
I will set `i`, `m` and `n` to a numerically correct solution, but
from there on it's a properly abtracted proof:

    # These values are deduced below and
    # used by irb to computationally verify the statements
    # for the particular case i=1.
    i = 1
    m = 2*i
    n = 3*i

    # These equivalences are used in the proof below.
    16**n == 64**m #=> true
    2**4  == 16    #=> true
    2**6  == 64    #=> true

    # OK, looking for entropies
    # that will fit both in base 16 and 64!
    16**n == 64**m           #=> true
    Lb[16**n]  == Lb[64**m]  #=> true
    n*Lb[16]   == m*Lb[64]   #=> true
    n*Lb[2**4] == m*Lb[2**6] #=> true
    4*n*Lb[2]  == 6*m*Lb[2]  #=> true
    4*n == 6*m               #=> true
    2*n == 3*m               #=> true
    # Substituting m=2i,n=3i satisfies the condition.
    m == 2*i                 #=> true
    n == 3*i                 #=> true
    2*(3*i) == 3*(2*i)       #=> true
    6*i == 6*i               #=> true
    i == i                   #=> true

So what's the lowest base 64 and 16 commensurable entropy above `2**256`?

     E.length(2**256, 16) #=> 64
     E.length(2**256, 64) #=> 43

     # Get i somehow.
     i = (43/2.0).ceil #=> 22
     i = (64/3.0).ceil #=> 22
     i = (1..100).detect{|i| 3*i >= 64 and 2*i >= 43} #=> 22
     # Then get m and n.
     m = 2*i #=> 44
     n = 3*i #=> 66

     16**66 == 64**44                   #=> true
     Lb[16**66]                         #=> 264.0
     Lb[64**44]                         #=> 264.0
     2**264==16**66 and 2**264==64**44  #=> true

So, does Entropia's equilence among bases 2, 16, and 64 work?
With entropy `2**264`, yes!:

    e2 = E[264]{RNG}
    e16 = e2*16
    e64 = e2*64

    e16
    #=> C0FA86BB52793E6063CC95A7D8CD087CB1762382F3853E031DC7D0C293ADCB0C93
    e64
    #=> mFg6kr9vFc1Zp9MdsCq8VB5s8uBpXJu37SVGmfEjomoJ

    e2  == e16  #=> true
    e2  == e64  #=> true
    e16 == e64  #=> true

## 60 bits

For fun, I'd like to find the lowest entropy that can be neatly be expressed
in base 2, 4, 8, 16, 32, and 64.
I run out of graph characters at base 94, so
base 128 and above require thought on new symbols,
so I'll stop at base 64:

    length64 = (1..100).detect{|l| e=64**l; [32,16,8,4,2].all?{|b| Math.log(e,b)%1==0}} #=> 10
    # or equivalently(Math.log can have floating point rounding problems)...
    length64 = (1..100).detect{|l| e=64**l; [32,16,8,4,2].all?{|b| Entropia.commensurable?(e, b)}} #=> 10
    entropy = 64**length64
    bits = Lb[entropy] #=> 60.0

With a 60 bits entropy, there's no problem expressing it in bases powers of twos up to 64(`2**6`):

    e2 = E[60]{RNG}
    e4 = e2*4    #=> 321013032320322320132312012213
    e8 = e2*8    #=> 71071670727036660647
    e16 = e2*16  #=> E473B8EB87B61A7
    e32 = e2*32  #=> SHPRHQS7MOD7
    e64 = e2*64  #=> v7EuwuUs6d
    [e4,e8,e16,e64].all?{|e| e == e2} #=> true

And I can add these entropies. Entropia does reasonable things automatically:

    e = e2+e4+e8+e16+e32+e64
    e.base #=> 64
    # should have 360(60*6) bits, right?
    e.bits #=> 360.0
    e
    #=> v7EuwuUs6dv7EuwuUs6dv7EuwuUs6dv7EuwuUs6dv7EuwuUs6dv7EuwuUs6d

## Properties of Entropia's operators

With commensurability issues aside,
I'll illustrate some properties concat and base conversions have.

    a = E[60]{RNG}*64 #=> FHtI2K?p?1
    b = E[60]{RNG}*64 #=> IopGc9aKgv

Obviously, the concat operator does not commute, but
some properties do preserve:

    a+b  #=> FHtI2K?p?1IopGc9aKgv
    b+a  #=> IopGc9aKgvFHtI2K?p?1
    a+b == b+a                           #=> false
    (a+b).to_s == (b+a).to_s             #=> false
    (a+b).to_i == (b+a).to_i             #=> false
    (a+b).bits == (b+a).bits             #=> true
    (a+b).entropy == (b+a).entropy       #=> true
    (a+b).randomness == (b+a).randomness #=> true

Nicely, base conversion distributes:

    (a + b)*8 == a*8 + b*8 #=> true
    ((a + b)*8).to_s == (a*8 + b*8).to_s #=> true

This of course will all be very useful someday, but
for now I just find the above very interesting.  :P


## XOR-cipher

[XOR-cipher](http://en.wikipedia.org/wiki/XOR_cipher) is very easy to implement.
These are the facts one needs to consider, as explained in Wikipedia:

> If the key is random and is at least as long as the message,
> the XOR cipher is much more secure than when there is key repetition within a message.
> When the keystream is generated by a pseudo-random number generator, the result is a stream cipher.
> With a key that is truly random, the result is a one-time pad, which is unbreakable even in theory.

Just a quick review of xor:

    false ^ false #=> false
    false ^ true  #=> true
    true  ^ false #=> true
    true  ^ true  #=> false

    0 ^ 0 #=> 0
    0 ^ 1 #=> 1
    1 ^ 0 #=> 1
    1 ^ 1 #=> 0

    97 ^  3 == 98 #=> true
    98 ^  3 == 97 #=> true
    97 ^ 98 ==  3 #=> true

Entropia has an xor operator with which I can demonstrate an xor cipher:

    message = E.new 'My top secret message!'
    #=> My top secret message! 95:P95 0.0% -

    key = E.new RNG.random_number(95**16), base: 95
    #=> _BX;LhGj_<4`2BF9 95:P95 0.0% -

    cipher = key^message
    #=>  e{Tt1!DM%b{BJBZ)/NAER 95:P95 0.0% -

    key^cipher
    #=> My top secret message! 95:P95 0.0% -

The key was randomly generated, but
I did not specify that in its construction.
I can set it though:

    key.randomness #=> 0.0
    key.set_randomness(key.bits)
    key.randomness #=> 105.11768973329517
    key #=> _BX;LhGj_<4`2BF9 95:P95 100% -

Now the key shows to be 100% random.
Then the contructed cipher will calcutate it's randomness:

    cipher = key^message
    #=>  e{Tt1!DM%b{BJBZ)/NAER 95:P95 73% -

The cipher shows it's 73% random.
That is because the key's randomness did not cover the entire entropy of the message.

Now, please note that when the message is decoded from the cipher,
Entropia erroneously also gives the decode a 73% random value.
I have some ideas as to how to handle this for future versions of Entropia, but
for now (version 0.1), one just needs to be aware of the issue:

    decode = key^cipher
    decode
    #=> My top secret message! 95:P95 73% -
    # 73% random here is a known issue in Entropia.

    'stop' #=> now

#
# ***Cryptographic hash function***
#

# `otpr` uses SHA512 and MD5 digests[http://en.wikipedia.org/wiki/Cryptographic_hash_function].
# The their useful properties are:
#    1) It is infeasible to generate a message that has a given hash.
#    2) It is infeasible to modify a message without changing the hash.
#    3) It is infeasible to find two different messages with the same hash.
# I use MD5 to name a pin's files.  Given a pin, I know the files to use for the pin,
# but knowing the file names does not tell me the pin.
# And I use SHA512 to create the encription key.
# The reason is a bit subtle.
# The encription key should be random, but often times it's based on a meaningful message.
# SHA512 completely scrambles any message (or lack of randomness)
# that might otherwise creep into the encription key.

#
# ***Salt***
#

# Salt[http://en.wikipedia.org/wiki/Salt_(cryptography)] is added to the pin
# to project the final encription key from attempts at getting the key by simply guessing the pin.
# The salt is combined from two salt files, one in the removable media (yin salt), and
# one in a secured cache directory (yang salt).

  s0 = E[256]
  s0.randomness
  #=> 0
  s1 = E.new.pp(256, random: true){|n| rand(n)}
  s1.randomness
  #=> 256

# For the yang salt, the library gets random bits from random.org to guarantee randomness.
# But for our analysis here, we just call rand and pretend it's random.
 
# s0*Q and s1*Q is what's stored in the salt files.
# This makes it easier to inspect.
# The combined salt is:

  s = s0*Q + s1*Q
  s.randomness
  #=> 256
  s.bits
  #=> 512
  s.shuffled?
  #=> false

# Note that the first part of the string is pseudo-random, while second is real random.
# This won't matter, as it'll all go into SHA512(but Entropia keeps track of the shuffle state).
# The passphrase is the salted pin, which is given by the user.
# I'll denote the pin as p, and the passphrase as w:

  p = Entropia.new 'ThePin', Q # whatever the user says
  w = p + s
  # or expanded out...
  w = p + s0*Q + s1*Q
  # Looks like "ThePin..."
  w.randomness
  #=> 256
  w.bits
  #=> Greater than 512
  w.shuffled?
  #=> false

# I don't know if it matters, but in case the digest preserves any information,
# I feed in order of increasing randomness: p, s0, s1 => p+s0*Q+s1*Q.
# The SHA512 digest of w is a binary string of length 64.

  k0 = D[w]
  k0.length
  #=> 64
  k0.bits
  #=> 512.0
  k0.randomness
  #=> 256.0
  k0.shuffled?
  #=> true (I think we can agree on this)
  k0.class
  #=> String
  # Entropia handles digests separately.  The String instance is extended.

# Because this is going to be one of the encriptions key,
# the secret(master-password) should not be much bigger than 64 characters.
# The key, k0, can be assumed to have an entropy capacity of 512 bits, and
# since our salt had at least 256 bits of randomness, this key should be good to go!
# Expanded out, k0 is:

  k0 = D[ p + s0*Q + s1*Q ]

# Now we can do our first encription.
# Given our plain text passwoard, P:

  P = Entropia.new 'Top_Secret_Password!', Q
  c0 = k0^P  # => looks like S{)\xABI\x02...
  k0^c0      # => 'Top_Secret_Password!'
  (k0^c0).class #=> String: remember that k0 is an extended String, so xor returns a String.
  P.to_s == k0^c0
  #=> true: So to test equality, we need to convert P to a string.


# Tada!
# Expanded all out:

   c0 = D[ p + s0*Q + s1*Q ] ^ P

   D[ p + s0*Q + s1*Q ] ^ c0
   #=> "Top_Secret_Password!"

# To store the encripted secret, and allow the use of multiple pins,
# I need a filename, f, that's based on the pin, but
# that cannot be reversed back to the pin.

   # Looks like 1Rpq3qgBnMMLC3aPUsS7t
   f = C[w]*W

   # or expanded out...
   f = C[p + s0*Q + s1*Q]*W
   # You can verify that
   C[w]*W == C[p + s0*Q + s1*Q]*W
   #=> true

# I save the secret in the cache directory under the name of f.
# But what if at some point, because the salts and pin don't change,
# the passphrase to the secret is compromised?
# The p(pin) is in your head, s0(Yin's salt) is in removable media, and
# s1(Yang's salt) is in a user only readable directory.
# How is the passphrase going to be compromised?  LOL.
# But let's make it as near impossible as possible!  :P
# I re-encript with a new random key and save the key in the removable media under f.

  q = E[256]*Q
  k1 = D[q]

# BTW, here k1 has 256 bits of entropy, not more.

  c1 = k1^c0
  c0 == k1^c1 #=> true

# q is saved in yin/f and c1 is saved in yang/f.
# The --regen option allows one to re-generate the two files.
# The regenaration does not need to know the passphrase.
# So if at anytime any either Yin or Yang is compromised,
# just regenarate all the pads.

#
# ***Entropy from words?***
#

# The file
#    /usr/share/dict/american-english
# has just under 100,000 words.

   # DICTIONARY = `wc /usr/share/dict/american-english`.strip.split(/\s+/).first.to_i
   #=> 99171
   # or
   DICTIONARY = 99171

# If we treat this as the size of the base,
# we can get a rough estimate of the entropy in a line of text.
# (Of course, it's true entropy is more complicated)
# For 16 words, we get over 256 bits of entropy:

  DICTIONARY**16 > 2**256
  #=> true

# To determine the number of words needed for n bits of entropy
# I'll use:

  n = 256 # for example...
  (1 + n*Lb[2]/Lb[DICTIONARY]).round
  #=> 16

# The added *1* ensures at least one word.

# My computer can run `otpr` about 10 times per second.
# For the purpose of cracking, one can do a lot better
# by looking at the code and figuring out the most streamline way to
# start guessing a pin.  But I'm looking for some minimum standards.
# At a time of 0.1 seconds, what does it crack in 2 weeks (1 week on average)?

  total_time = 60*60*24*7*2
  bits = total_time / 0.1 # 10 per second
  n = (Lb[bits]/Lb[2]).round #=> ~ 24 bit of entropy
  Lb[2]*n/Lb[256] #=> 3
  Lb[2]*n/Lb[91]  #=> ~3.7 (Q passwords length)
  Lb[2]*n/Lb[62]  #=> ~4.0 (W passwords length)
  Lb[2]*n/Lb[10]  #=> ~7.2 (Digits password)

# Lets see how quickly is cracks a 3 letter (62 base) password.

  bits = 62**3
  total_time = bits * 0.1 # 1209600.0 seconds
  total_time / (60*60) # ~6.6 hours

# On average, just over 3 hours.
# How about a 4 letter (62 base) password.

  bits = 62**4
  total_time = bits * 0.1
  total_time / (60*60*24) # ~17 days

# Note that this assumes the attacker has access to all your files.
# Nonetheless, I think it makes sense to enforce
# a minimun pin of 3 characters, if not 4.
# Basically it's just enough to stop that guy in the next cubicle
# from guessing one of you pins while you're out on a coffee break
# and you forget to lock your screen.
# You know.  That guy...  I hate that guy!