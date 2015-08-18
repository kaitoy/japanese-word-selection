JapaneseWordSelection = require '../lib/japanese-word-selection'

describe 'JapaneseWordSelection', ->
  editor = null

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage('japanese-word-selection')

    waitsForPromise ->
      atom.workspace.open().then (o) -> editor = o

    runs ->
      editor.insertText('''
                            ああああホゲんんんん
                            ああああﾎｹﾞんんんん
                            ああああ穂毛んんんん
                            ああああhogeんんんん
                            ああああ1234んんんん
                            ''')

  describe 'Hiragana-Katakana-Hiragana', ->
    beforeEach ->
      runs ->
        editor.moveToTop()
        editor.moveToBeginningOfLine()

    it 'selects the first Hiragana word from the left edge', ->
      editor.selectToEndOfWord()
      expect(editor.getSelectedText() ).toEqual('ああああ')

    it 'selects the first Hiragana word from the middle of it', ->
      editor.moveRight(1)
      editor.selectWordsContainingCursors()
      expect(editor.getSelectedText() ).toEqual('ああああ')

    it 'selects the first Hiragana word from the right edge', ->
      editor.moveRight(4)
      editor.selectToBeginningOfWord()
      expect(editor.getSelectedText() ).toEqual('ああああ')

    it 'selects the Katakana word from the left edge', ->
      editor.moveRight(4)
      editor.selectToEndOfWord()
      expect(editor.getSelectedText() ).toEqual('ホゲ')

    it 'selects the Katakana word from the middle of it', ->
      editor.moveRight(5)
      editor.selectWordsContainingCursors()
      expect(editor.getSelectedText() ).toEqual('ホゲ')

    it 'selects the Katakana word from the right edge', ->
      editor.moveRight(6)
      editor.selectToBeginningOfWord()
      expect(editor.getSelectedText() ).toEqual('ホゲ')

    it 'selects the second Hiragana word from the left edge', ->
      editor.moveRight(6)
      editor.selectToEndOfWord()
      expect(editor.getSelectedText() ).toEqual('んんんん')

    it 'selects the second Hiragana word from the middle of it', ->
      editor.moveRight(8)
      editor.selectWordsContainingCursors()
      expect(editor.getSelectedText() ).toEqual('んんんん')

    it 'selects the second Hiragana word from the right edge', ->
      editor.moveRight(10)
      editor.selectToBeginningOfWord()
      expect(editor.getSelectedText() ).toEqual('んんんん')

  describe 'Hiragana-HWKatakana-Hiragana', ->
    beforeEach ->
      runs ->
        editor.moveToTop()
        editor.moveDown()
        editor.moveToBeginningOfLine()

    it 'selects the first Hiragana word from the left edge', ->
      editor.selectToEndOfWord()
      expect(editor.getSelectedText() ).toEqual('ああああ')

    it 'selects the first Hiragana word from the middle of it', ->
      editor.moveRight(1)
      editor.selectWordsContainingCursors()
      expect(editor.getSelectedText() ).toEqual('ああああ')

    it 'selects the first Hiragana word from the right edge', ->
      editor.moveRight(4)
      editor.selectToBeginningOfWord()
      expect(editor.getSelectedText() ).toEqual('ああああ')

    it 'selects the half-width Katakana word from the left edge', ->
      editor.moveRight(4)
      editor.selectToEndOfWord()
      expect(editor.getSelectedText() ).toEqual('ﾎｹﾞ')

    it 'selects the half-width Katakana word from the middle of it', ->
      editor.moveRight(5)
      editor.selectWordsContainingCursors()
      expect(editor.getSelectedText() ).toEqual('ﾎｹﾞ')

    it 'selects the half-width Katakana word from the right edge', ->
      editor.moveRight(7)
      editor.selectToBeginningOfWord()
      expect(editor.getSelectedText() ).toEqual('ﾎｹﾞ')

    it 'selects the second Hiragana word from the left edge', ->
      editor.moveRight(7)
      editor.selectToEndOfWord()
      expect(editor.getSelectedText() ).toEqual('んんんん')

    it 'selects the second Hiragana word from the middle of it', ->
      editor.moveRight(9)
      editor.selectWordsContainingCursors()
      expect(editor.getSelectedText() ).toEqual('んんんん')

    it 'selects the second Hiragana word from the right edge', ->
      editor.moveRight(11)
      editor.selectToBeginningOfWord()
      expect(editor.getSelectedText() ).toEqual('んんんん')

  describe 'Hiragana-Kanji-Hiragana', ->
    beforeEach ->
      runs ->
        editor.moveToTop()
        editor.moveDown(2)
        editor.moveToBeginningOfLine()

    it 'selects the first Hiragana word from the left edge', ->
      editor.selectToEndOfWord()
      expect(editor.getSelectedText() ).toEqual('ああああ')

    it 'selects the first Hiragana word from the middle of it', ->
      editor.moveRight(1)
      editor.selectWordsContainingCursors()
      expect(editor.getSelectedText() ).toEqual('ああああ')

    it 'selects the first Hiragana word from the right edge', ->
      editor.moveRight(4)
      editor.selectToBeginningOfWord()
      expect(editor.getSelectedText() ).toEqual('ああああ')

    it 'selects the Kanji word from the left edge', ->
      editor.moveRight(4)
      editor.selectToEndOfWord()
      expect(editor.getSelectedText() ).toEqual('穂毛')

    it 'selects the Kanji word from the middle of it', ->
      editor.moveRight(5)
      editor.selectWordsContainingCursors()
      expect(editor.getSelectedText() ).toEqual('穂毛')

    it 'selects the Kanji word from the right edge', ->
      editor.moveRight(6)
      editor.selectToBeginningOfWord()
      expect(editor.getSelectedText() ).toEqual('穂毛')

    it 'selects the second Hiragana word from the left edge', ->
      editor.moveRight(6)
      editor.selectToEndOfWord()
      expect(editor.getSelectedText() ).toEqual('んんんん')

    it 'selects the second Hiragana word from the middle of it', ->
      editor.moveRight(8)
      editor.selectWordsContainingCursors()
      expect(editor.getSelectedText() ).toEqual('んんんん')

    it 'selects the second Hiragana word from the right edge', ->
      editor.moveRight(10)
      editor.selectToBeginningOfWord()
      expect(editor.getSelectedText() ).toEqual('んんんん')

  describe 'Hiragana-Alphabet-Hiragana', ->
    beforeEach ->
      runs ->
        editor.moveToTop()
        editor.moveDown(3)
        editor.moveToBeginningOfLine()

    it 'selects the first Hiragana word from the left edge', ->
      editor.selectToEndOfWord()
      expect(editor.getSelectedText() ).toEqual('ああああ')

    it 'selects the first Hiragana word from the middle of it', ->
      editor.moveRight(1)
      editor.selectWordsContainingCursors()
      expect(editor.getSelectedText() ).toEqual('ああああ')

    it 'selects the first Hiragana word from the right edge', ->
      editor.moveRight(4)
      editor.selectToBeginningOfWord()
      expect(editor.getSelectedText() ).toEqual('ああああ')

    it 'selects the alphabet word from the left edge', ->
      editor.moveRight(4)
      editor.selectToEndOfWord()
      expect(editor.getSelectedText() ).toEqual('hoge')

    it 'selects the alphabet word from the middle of it', ->
      editor.moveRight(5)
      editor.selectWordsContainingCursors()
      expect(editor.getSelectedText() ).toEqual('hoge')

    it 'selects the alphabet word from the right edge', ->
      editor.moveRight(8)
      editor.selectToBeginningOfWord()
      expect(editor.getSelectedText() ).toEqual('hoge')

    it 'selects the second Hiragana word from the left edge', ->
      editor.moveRight(8)
      editor.selectToEndOfWord()
      expect(editor.getSelectedText() ).toEqual('んんんん')

    it 'selects the second Hiragana word from the middle of it', ->
      editor.moveRight(10)
      editor.selectWordsContainingCursors()
      expect(editor.getSelectedText() ).toEqual('んんんん')

    it 'selects the second Hiragana word from the right edge', ->
      editor.moveRight(12)
      editor.selectToBeginningOfWord()
      expect(editor.getSelectedText() ).toEqual('んんんん')

  describe 'Hiragana-Number-Hiragana', ->
    beforeEach ->
      runs ->
        editor.moveToTop()
        editor.moveDown(4)
        editor.moveToBeginningOfLine()

    it 'selects the first Hiragana word from the left edge', ->
      editor.selectToEndOfWord()
      expect(editor.getSelectedText() ).toEqual('ああああ')

    it 'selects the first Hiragana word from the middle of it', ->
      editor.moveRight(1)
      editor.selectWordsContainingCursors()
      expect(editor.getSelectedText() ).toEqual('ああああ')

    it 'selects the first Hiragana word from the right edge', ->
      editor.moveRight(4)
      editor.selectToBeginningOfWord()
      expect(editor.getSelectedText() ).toEqual('ああああ')

    it 'selects the number from the left edge', ->
      editor.moveRight(4)
      editor.selectToEndOfWord()
      expect(editor.getSelectedText() ).toEqual('1234')

    it 'selects the number from the middle of it', ->
      editor.moveRight(5)
      editor.selectWordsContainingCursors()
      expect(editor.getSelectedText() ).toEqual('1234')

    it 'selects the number from the right edge', ->
      editor.moveRight(8)
      editor.selectToBeginningOfWord()
      expect(editor.getSelectedText() ).toEqual('1234')

    it 'selects the second Hiragana word from the left edge', ->
      editor.moveRight(8)
      editor.selectToEndOfWord()
      expect(editor.getSelectedText() ).toEqual('んんんん')

    it 'selects the second Hiragana word from the middle of it', ->
      editor.moveRight(10)
      editor.selectWordsContainingCursors()
      expect(editor.getSelectedText() ).toEqual('んんんん')

    it 'selects the second Hiragana word from the right edge', ->
      editor.moveRight(12)
      editor.selectToBeginningOfWord()
      expect(editor.getSelectedText() ).toEqual('んんんん')
