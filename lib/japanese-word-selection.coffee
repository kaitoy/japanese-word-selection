{CompositeDisposable, Point} = require 'atom'

module.exports = JapaneseWordSelection =

  disposables: null

  activate: ->
    @disposables = new CompositeDisposable
    @disposables.add atom.workspace.observeTextEditors (editor) ->
      JapaneseWordSelection.disposables.add editor.observeCursors (cursor) ->
        JapaneseWordSelection.japanizeWordBoundary(cursor)

  japanizeWordBoundary: (cursor) ->
    cursor.orgGetBeginningOfCurrentWordBufferPosition = cursor.getBeginningOfCurrentWordBufferPosition
    cursor.getBeginningOfCurrentWordBufferPosition =  (options = {}) ->
      allowPrevious = options.allowPrevious ? true
      currentBufferPosition = @getBufferPosition()
      previousNonBlankRow = @editor.buffer.previousNonBlankRow(currentBufferPosition.row) ? 0
      scanRange = [[previousNonBlankRow, 0], currentBufferPosition]

      regex = JapaneseWordSelection.getRegex(@editor, @, options, false)
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

      regex = JapaneseWordSelection.getRegex(@editor, @, options, true)
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

  getRegex: (editor, cursor, options, forward) ->
    cursorPosition = cursor.getBufferPosition()
    col = if forward then cursorPosition.column + 1 else cursorPosition.column - 1
    cursorText = editor.getTextInBufferRange([[cursorPosition.row, col], cursorPosition])

    if /[\u3001-\u303F・ー]/.test(cursorText)
      # punctuations, symbols, etc.
      # [、-〿・ー]
      return /[\u3001-\u303F]+/g
    if /[\u3041-\u309E]/.test(cursorText)
      # Hiragana
      # [ぁ-ゞ]
      return /[\u3041-\u309E]+/g
    else if /[\u30A1-\u30FAヽヾ]/.test(cursorText)
      # Katakana
      # [ァ-ヺヽヾ]
      return /[\u30A1-\u30FAヽヾ]+/g
    else if /[\uFF66-\uFF9F]/.test(cursorText)
      # half-width Katakana
      # [ｦ-ﾟ]
      return /[\uFF66-\uFF9F]+/g
    else if /(?:[々〇〻\u3400-\u9FFF\uF900-\uFAFF]|[\uD840-\uD87F][\uDC00-\uDFFF])/.test(cursorText)
      # Kanji
      return /(?:[々〇〻\u3400-\u9FFF\uF900-\uFAFF]|[\uD840-\uD87F][\uDC00-\uDFFF])+/g
    else if options.wordRegex?
      return options.wordRegex
    else
      regex = cursor.wordRegExp(options).source
      regex = regex.replace(/\[\^/, '[^\u3001-\u303F・ー\u3041-\u309E\u30A1-\u30FAヽヾ\uFF66-\uFF9F々〇〻\\u3400-\\u9FFF\\uF900-\\uFAFF\\uD840-\\uD87F\\uDC00-\\uDFFF')
      return RegExp(regex, "g")

  deactivate: ->
    @disposables.dispose()
    for i, editor of atom.workspace.getTextEditors()
      for j, cursor of editor.getCursors()
        if cursor.orgGetBeginningOfCurrentWordBufferPosition?
          cursor.getBeginningOfCurrentWordBufferPosition = cursor.orgGetBeginningOfCurrentWordBufferPosition
          delete cursor.orgGetBeginningOfCurrentWordBufferPosition
          cursor.getEndOfCurrentWordBufferPosition = cursor.orgGetEndOfCurrentWordBufferPosition
          delete cursor.orgGetEndOfCurrentWordBufferPosition
