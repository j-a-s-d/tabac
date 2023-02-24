# tabac #

import
  xam

type
  TextLine* = tuple
    number: int
    length: int
    raw: string
  TextLines* = seq[TextLine]

func makeTextLine(number: int, text: string): TextLine {.inline.} =
  (
    number: number,
    length: len(text),
    raw: text
  )

func loadTextLines*(lines: StringSeq): TextLines =
  var number: int = 0
  for text in lines:
    number += 1
    result.add(makeTextLine(number, text))

