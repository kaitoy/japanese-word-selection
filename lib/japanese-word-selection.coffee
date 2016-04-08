{CompositeDisposable, Point, Range} = require 'atom'

module.exports = JapaneseWordSelection =

  # Regex string for punctuations, symbols, etc.
  # [、-〿・○■□▼▽△▲]
  _punctuationsRegexStr: '[\\u3001-\\u303F・○■□▼▽△▲]'

  # Regex string for Hiragana
  # [ぁ-ゞ]
  _hiraganaRegexStr: '[\\u3041-\\u309E]'

  # Regex string for Katakana
  # [ァ-ヺヽヾー]
  _katakanaRegexStr: '[\\u30A1-\\u30FAヽヾー]'

  # Regex string for half-width Katakana
  # [ｦ-ﾟ]
  _halfWidthKatakanaRegexStr: '[\\uFF66-\\uFF9F]'

  # Regex string for Kanji
  _kanjiRegexStr: '(?:[々〇〻\\u3400-\\u9FFF\\uF900-\\uFAFF]|[\\uD840-\\uD87F][\\uDC00-\\uDFFF])'

  _japaneseChars: null

  _disposables: new CompositeDisposable

  activate: ->
    @_japaneseChars = (@_punctuationsRegexStr + @_hiraganaRegexStr + @_katakanaRegexStr + @_halfWidthKatakanaRegexStr + @_kanjiRegexStr).replace(/\(|\?|:|\[|\||\]|\)/g, '')
    @_disposables.add atom.workspace.observeTextEditors (editor) =>
      @_disposables.add editor.observeCursors (cursor) =>
        @japanizeWordBoundary(cursor)

  japanizeWordBoundary: (cursor) ->
    cursor.orgGetBeginningOfCurrentWordBufferPosition = cursor.getBeginningOfCurrentWordBufferPosition
    cursor.getBeginningOfCurrentWordBufferPosition = (options = {}) ->
      options.wordRegex = JapaneseWordSelection.getRegex @, options, false
      @.orgGetBeginningOfCurrentWordBufferPosition options

    cursor.orgGetEndOfCurrentWordBufferPosition = cursor.getEndOfCurrentWordBufferPosition
    cursor.getEndOfCurrentWordBufferPosition = (options = {}) ->
      options.wordRegex = JapaneseWordSelection.getRegex @, options, true
      @.orgGetEndOfCurrentWordBufferPosition options

  getRegex: (cursor, options, forward) ->
    curPos = cursor.getBufferPosition()
    editor = cursor.editor
    targetChar = null
    if forward
      nextLine = editor.lineTextForBufferRow curPos.row + 1
      if nextLine?
        range = new Range curPos, [curPos.row + 1, nextLine.length - 1]
      else
        currentLine = editor.lineTextForBufferRow curPos.row
        range = new Range curPos, [curPos.row, currentLine.length - 1]
      editor.scanInBufferRange new RegExp('\\S'), range, ({matchText, stop}) ->
        targetChar = matchText
        stop()
    else
      if curPos.row == 0
        range = new Range [curPos.row, 0], curPos
      else
        range = new Range [curPos.row - 1, 0], curPos
      editor.backwardsScanInBufferRange new RegExp('\\S'), range, ({matchText, stop}) ->
        targetChar = matchText
        stop()
    return options.wordRegex if not targetChar?

    punctuationsRegex = new RegExp(@_punctuationsRegexStr + '+')
    if punctuationsRegex.test(targetChar)
      return punctuationsRegex

    hiraganaRegex = new RegExp(@_hiraganaRegexStr + '+')
    if hiraganaRegex.test(targetChar)
      return hiraganaRegex

    katakanaRegex = new RegExp(@_katakanaRegexStr + '+')
    if katakanaRegex.test(targetChar)
      return katakanaRegex

    halfWidthKatakanaRegex = new RegExp(@_halfWidthKatakanaRegexStr + '+')
    if halfWidthKatakanaRegex.test(targetChar)
      return halfWidthKatakanaRegex

    kanjiRegex = new RegExp(@_kanjiRegexStr + '+')
    if kanjiRegex.test(targetChar)
      return kanjiRegex

    if options.wordRegex?
      return options.wordRegex

    regex = cursor.wordRegExp(options).source
    regex = regex.replace(/\[\^/, "[^#{@_japaneseChars}")
    return RegExp(regex, 'g')

  deactivate: ->
    @_disposables.dispose()
    for editor in atom.workspace.getTextEditors()
      for cursor in editor.getCursors()
        if cursor.orgGetBeginningOfCurrentWordBufferPosition?
          cursor.getBeginningOfCurrentWordBufferPosition = cursor.orgGetBeginningOfCurrentWordBufferPosition
          delete cursor.orgGetBeginningOfCurrentWordBufferPosition
          cursor.getEndOfCurrentWordBufferPosition = cursor.orgGetEndOfCurrentWordBufferPosition
          delete cursor.orgGetEndOfCurrentWordBufferPosition
