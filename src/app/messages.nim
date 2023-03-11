# tabac #

import
  rodster, xam

let APP_INFO* = (
  BANNER: "APP_INFO.BANNER"
)

let APP_ERROR* = (
  UNEXPECTED: "APP_ERROR.UNEXPECTED",
  INEXISTENT: "APP_ERROR.INEXISTENT",
  EMITTED: "APP_ERROR.EMITTED",
  UNWRITABLE: "APP_ERROR.UNWRITABLE"
)

let TABAC_ERRORS* = (
  FORBIDDEN_TRAILING_COMMENT: "TABAC_ERRORS.FORBIDDEN_TRAILING_COMMENT",
  FORBIDDEN_MULTILINE_COMMENT: "TABAC_ERRORS.FORBIDDEN_MULTILINE_COMMENT",
  FORBIDDEN_CODE_LINE: "TABAC_ERRORS.FORBIDDEN_CODE_LINE",
  FORBIDDEN_NONCODE_LINE: "TABAC_ERRORS.FORBIDDEN_NONCODE_LINE"
)

template addMessage(builder: JArrayBuilder, code, message: string): JArrayBuilder =
  builder.add(newJObjectBuilder().set("code", code).set("message", message).getAsJObject())

template getENMessages(): JArrayBuilder =
  newJArrayBuilder()
    .addMessage(APP_INFO.BANNER, "// generated with $1 @ $2")
    .addMessage(APP_ERROR.UNEXPECTED, "an unexpected error occurred: $1")
    .addMessage(APP_ERROR.INEXISTENT, "does not exist: $1")
    .addMessage(APP_ERROR.EMITTED, "emitted: $1 ($2 bytes)")
    .addMessage(APP_ERROR.UNWRITABLE, "could not be written: $1")
    .addMessage(TABAC_ERRORS.FORBIDDEN_TRAILING_COMMENT, "<$1:$2> forbidden trailing comment and/or misleading string found (remove or escape)")
    .addMessage(TABAC_ERRORS.FORBIDDEN_MULTILINE_COMMENT, "<$1:$2> forbidden multiline comment and/or misleading string found (remove or escape)")
    .addMessage(TABAC_ERRORS.FORBIDDEN_CODE_LINE, "<$1:$2> forbidden code line found (apply any of the grant rules)")
    .addMessage(TABAC_ERRORS.FORBIDDEN_NONCODE_LINE, "<$1:$2> forbidden non-code line found (apply any of the grant rules)")

template getESMessages(): JArrayBuilder =
  newJArrayBuilder()
    .addMessage(APP_INFO.BANNER, "// generado por $1 @ $2")
    .addMessage(APP_ERROR.UNEXPECTED, "un error inesperado ha ocurrido: $1")
    .addMessage(APP_ERROR.INEXISTENT, "no existe: $1")
    .addMessage(APP_ERROR.EMITTED, "emitido: $1 ($2 bytes)")
    .addMessage(APP_ERROR.UNWRITABLE, "no pudo ser escrito: $1")
    .addMessage(TABAC_ERRORS.FORBIDDEN_TRAILING_COMMENT, "<$1:$2> comentario trasero prohibido y/o string engañoso encontrado (remover o escapar)")
    .addMessage(TABAC_ERRORS.FORBIDDEN_MULTILINE_COMMENT, "<$1:$2> comentario multilinea prohibido y/o string engañoso encontrado (remover o escapar)")
    .addMessage(TABAC_ERRORS.FORBIDDEN_CODE_LINE, "<$1:$2> linea de código prohibida encontrada (aplicar cualquiera de las reglas de conceción)")
    .addMessage(TABAC_ERRORS.FORBIDDEN_NONCODE_LINE, "<$1:$2> linea de no-código prohibida encontrada (aplicar cualquiera de las reglas de conceción)")

template getPTMessages(): JArrayBuilder =
  newJArrayBuilder()
    .addMessage(APP_INFO.BANNER, "// gerado por $1 @ $2")
    .addMessage(APP_ERROR.UNEXPECTED, "um erro inesperado ocorreu: $1")
    .addMessage(APP_ERROR.INEXISTENT, "não existe: $1")
    .addMessage(APP_ERROR.EMITTED, "emitido: $1 ($2 bytes)")
    .addMessage(APP_ERROR.UNWRITABLE, "não pode ser escrito: $1")
    .addMessage(TABAC_ERRORS.FORBIDDEN_TRAILING_COMMENT, "<$1:$2> comentário traseiro proibido e/ou string enganoso encontrado (remover ou escapar)")
    .addMessage(TABAC_ERRORS.FORBIDDEN_MULTILINE_COMMENT, "<$1:$2> comentário multilinha proibido e/ou string enganoso encontrado (remover ou escapar)")
    .addMessage(TABAC_ERRORS.FORBIDDEN_CODE_LINE, "<$1:$2> linha de código proibida encontrada (aplicar qualquer uma das regras de concessão)")
    .addMessage(TABAC_ERRORS.FORBIDDEN_NONCODE_LINE, "<$1:$2> linha de não-código proibida encontrada (aplicar qualquer uma das regras de concessão)")

proc loadMessages*(i18n: RodsterAppI18n) =
  template loadLanguageMessages(language: string, builder: JArrayBuilder) =
    discard i18n.loadTextsFromJArray(language, builder.getAsJArray())
  loadLanguageMessages(LANGUAGE_CODES.EN, getENMessages())
  loadLanguageMessages(LANGUAGE_CODES.ES, getESMessages())
  loadLanguageMessages(LANGUAGE_CODES.PT, getPTMessages())

