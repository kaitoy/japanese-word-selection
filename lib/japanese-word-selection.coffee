{CompositeDisposable, Point} = require 'atom'

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
    cursor.getBeginningOfCurrentWordBufferPosition =  (options = {}) ->
      allowPrevious = options.allowPrevious ? true
      currentBufferPosition = @getBufferPosition()
      previousNonBlankRow = @editor.buffer.previousNonBlankRow(currentBufferPosition.row) ? 0
      scanRange = [[previousNonBlankRow, 0], currentBufferPosition]

      regex = JapaneseWordSelection.getRegex(@, options, false)
      beginningOfWordPosition = null
      @editor.backwardsScanInBufferRange regex, scanRange, ({range, stop}) ->
        if range.end.isGreaterThanOrEqual(currentBufferPosition) or allowPrevious
          beginningOfWordPosition = range.start
        if not beginningOfWordPosition?.isEqual(currentBufferPosition)
          stop()

      if beginningOfWordPosition?
        beginningOfWordPosition
      else if allowPrevious
        new Point(0, 0)
      else
        currentBufferPosition

    cursor.orgGetEndOfCurrentWordBufferPosition = cursor.getEndOfCurrentWordBufferPosition
    cursor.getEndOfCurrentWordBufferPosition =  (options = {}) ->
      allowNext = options.allowNext ? true
      currentBufferPosition = @getBufferPosition()
      scanRange = [currentBufferPosition, @editor.getEofBufferPosition()]

      regex = JapaneseWordSelection.getRegex(@, options, true)
      endOfWordPosition = null
      @editor.scanInBufferRange regex, scanRange, ({range, stop}) ->
        if allowNext
          if range.end.isGreaterThan(currentBufferPosition)
            endOfWordPosition = range.end
            stop()
        else
          if range.start.isLessThanOrEqual(currentBufferPosition)
            endOfWordPosition = range.end
          stop()

      endOfWordPosition ? currentBufferPosition

  getRegex: (cursor, options, forward) ->
    cursorPosition = cursor.getBufferPosition()
    col = if forward then cursorPosition.column + 1 else cursorPosition.column - 1
    cursorText = cursor.editor.getTextInBufferRange([[cursorPosition.row, col], cursorPosition])

    punctuationsRegex = new RegExp(@_punctuationsRegexStr + '+')
    if punctuationsRegex.test(cursorText)
      return punctuationsRegex

    hiraganaRegex = new RegExp(@_hiraganaRegexStr + '+')
    if hiraganaRegex.test(cursorText)
      return hiraganaRegex

    katakanaRegex = new RegExp(@_katakanaRegexStr + '+')
    if katakanaRegex.test(cursorText)
      return katakanaRegex

    halfWidthKatakanaRegex = new RegExp(@_halfWidthKatakanaRegexStr + '+')
    if halfWidthKatakanaRegex.test(cursorText)
      return halfWidthKatakanaRegex

    kanjiRegex = new RegExp(@_kanjiRegexStr + '+')
    if kanjiRegex.test(cursorText)
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
