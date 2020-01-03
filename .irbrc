# Entropia
require 'entropia'
include ENTROPIA

# IRB Tools
require 'irbtools/configure'
_ = ENTROPIA::VERSION.split('.')[0..1].join('.')
Irbtools.welcome_message = "### Entropia(#{_}) ###"
require 'irbtools'
IRB.conf[:PROMPT][:ENTROPIA] = {
  PROMPT_I:    '> ',
  PROMPT_N:    '| ',
  PROMPT_C:    '| ',
  PROMPT_S:    '| ',
  RETURN:      "=> %s \n",
  AUTO_INDENT: true,
}
IRB.conf[:PROMPT_MODE] = :ENTROPIA
