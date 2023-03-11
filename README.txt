tabac
-----

DESCRiPTiON
-----------

  tabac, which stands for tab-a-c, is an experimental and very highly
  opinionated c-language strict preprocessing helper and syntax lenient
  transpiler aiming to enhance source code readability and speed up the
  coding process by forcing some structural simplicity, it gets your
  tabac special c compatible-like code and emits plain c source code

HiSTORY
-------

  . 1.1.1 . 11.mar.2023 . small fixes, lite-xl plugin & xam update
  . 1.1.0 . 01.mar.2023 . directives handling improvements
  . 1.0.0 . 24.feb.2023 . first public release
  . 0.1.0 . 23.feb.2023 .
  . 0.0.9 . 22.feb.2023 .
  . 0.0.8 . 21.feb.2023 .
  . 0.0.7 . 20.feb.2023 .
  . 0.0.6 . 19.feb.2023 .
  . 0.0.5 . 18.feb.2023 .
  . 0.0.4 . 17.feb.2023 .
  . 0.0.3 . 16.feb.2023 .
  . 0.0.2 . 15.feb.2023 .
  . 0.0.1 . 14.feb.2023 . started coding

MOTiVATiON
----------

  "If you want more effective programmers, you will discover that they
   should not waste their time debugging, they should not introduce the
   bugs to starth with."
  - Edger Dijkstra, The Humble Programmer, 1972

BUILD
-----

  to build the tabac application from source you need to:

    * install git (this vcs)
    * clone the repository (this one)
    * install nim (language compiler)
    * install nimble (package manager)
    * install xam and rodster (base packages)
    * run the build.sh (shell script)

CHARACTERiSTiCS
---------------

  tabac tries to force you to write code in a clear, concise and simple
  fashion in every single aspect and with the following rules in mind:

  * SPACED CODE BLOCKS

    tabac code requires to be organized in an spaced (or tabbed) fashion
    (like in python, nim, etc) avoiding completely the use of the usual
    curly-braced syntax (don't worry, you can still include self-closing
    small curly-braced blocks as long as you close the line following the
    rules)

  * CODE LiNES ETiQUETTE

    tabac has a line-based approach to your code and it enforces certain
    strict rules to determine if those lines are admitted in the output
    or not... so, to be granted by tabac a code line must...

    - finish with any of the following characters:

        ')', ';', ':', ',', '\' or '='

    - or, be in the following single keyword group:

        'do' and 'else'

    - or, start with any of the following keywords:

        'enum', 'struct', 'union',
        'typedef', 'static', 'const',
        '__try', '__except' or '__finally'

  * FORBiDDEN MISLEADING CONTENT

    to avoid very common code smells (like commenting out dead code and
    leaving it there, writing long notes instead of good technical
    documentation, and very long etcetera), the following things are
    simply rejected by tabac:

    - multiline code statemets and comments are totally forbidden (but
      you can still add various statements separated by ';' if you really
      need it)

    - trailing comments are usually misused, so tabac directly denies
      them at all, in fact it forbids '//' at any part of the line except
      in the beginning of it, so if you need to add '//' inside a string
      just escape it as \x2F\x2F or other equivalent sequence of chars

    - same happens with the multiline comment marker, tabac disallows
      '/*' at any part of the line except for the case where '*/' closes
      the line, so if you need to add '/*' inside a string just escape it
      as \x2F\x2A or any other equivalent sequence of chars

    - non-code (empty, comment and directive) lines after the last line
      of code of a block are not granted, for example:

        if (x == 0)
          x = 1;
        else
          // this line will be granted
          x = 2;
          // but this will be denied

    and also have in mind that any leading empty lines, at the beginning
    of the file, will be removed by default and that's not negotiable

  * RELEVANT SiDE NOTES

    also, there are some things to mention on very specific corner cases:

    - inline struct, enum variable and typedef alias declarations are not
      handled, instead declare properly in a new line, for example:

        struct Person
          int id;
          int age;
        struct Person pA, pB, p20[20];

      or:

        struct tag_name
           int x;
        typedef struct tag_name some_alias;

    - in switches, cases and default sentences must be placed with a
      higher indentation than the switch statement to be filiated as
      expected, for example:

        switch (x)
          case 1:
            test();
            break;
          case 2:
            test();
            break;
          default:
            discard;

    - directives starting with '#' are not processed for conditions so
      try to group complete blocks or isolated statements (like those
      ending ';') with the same indentation so they will be kept inside
      the current block, for example:

        if (x == 2)
          int z = 0;
        #ifdef X
          int xyz = 123;
        #endif
          z = 1;

    - also keep present that if you are opening blocks inside conditional
      defines you will have to close them before exiting the conditional
      code, you can do that with a comment line or even a blank line, for
      example:

        #ifdef X
          struct ABC
            int field;
        
        #endif

  * SOME CONFiGURABLE OPTiONS

    in the tabac.cfg file (located in the same directory than the tabac
    executable) you can tweak some options to adjust your personal taste
    regarding certain characteristics of the emitted source code, that
    way you can customize several things that tabac also does while
    working:

    - replace tabs with spaces (4 by default)

    - keep untouched or totally remove (default) comment lines

    - delete, keep or shrink (erase repeated leaving only one, which is
      the default behaviour) empty/blank lines

    if the tabac.cfg file is not there, you can create it with a json
    content like this:

      {
        "messages-language-code": "en",
        "spaces-per-tab": 4,
        "strip-comment-lines": false,
        "blank-lines-removal": "shrink"
      }

    just place it as usual in the directory where you are going to run
    tabac, so it can find it

  * FiNAL OBViOUS REMiNDER

    watch out, tabac is not perfect, besides all the imposed limitations,
    you can still (in a minor rate) generate garbage code on purpose just
    like when coding directly

    tabac is strict in the structure but totally lenient in the content,
    so it does not mess with your code in a c-syntax level by any means,
    it just helps you out to keep things clear and ordered even without
    any curly-braced sign around

USAGE
-----

  * BRIEF

    tabac receives two parameters from the command line, the input file
    and the output file (this one is optional, if not provided then the
    output filename will be formed by the name without extension of the
    input filename and the extension .c) which will be written and, if
    it does exist, overwriten with the generated c source code

  * SYNTAX

    tabac <input.file> [<output.file>]

      -- examples:

         tabac foo.tabac bar.c

         tabac abc1.tabac def2.other

         tabac something anything.c

         tabac fromFile.tabac toFile

         tabac sample.tabac

         tabac myFile
