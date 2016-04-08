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
        ほげ、Hoge、ほげ
        ホゲ・Hoge・ホゲ
        穂毛。Hoge。穂毛
        ほげ「Hoge」ほげ
        hogeホーゲーほげ
        □ほげ▼hoge■ホゲ
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

  describe 'ほげ、Hoge、ほげ', ->
    beforeEach ->
      runs ->
        editor.moveToTop()
        editor.moveDown(5)
        editor.moveToBeginningOfLine()

    it 'selects the first ほげ from the left edge', ->
      editor.selectToEndOfWord()
      expect(editor.getSelectedText() ).toEqual('ほげ')

    it 'selects the first ほげ from the middle of it', ->
      editor.moveRight(1)
      editor.selectWordsContainingCursors()
      expect(editor.getSelectedText() ).toEqual('ほげ')

    it 'selects the first ほげ from the right edge', ->
      editor.moveRight(2)
      editor.selectToBeginningOfWord()
      expect(editor.getSelectedText() ).toEqual('ほげ')

    it 'selects the Hoge from the left edge', ->
      editor.moveRight(3)
      editor.selectToEndOfWord()
      expect(editor.getSelectedText() ).toEqual('Hoge')

    it 'selects the Hoge from the middle of it', ->
      editor.moveRight(5)
      editor.selectWordsContainingCursors()
      expect(editor.getSelectedText() ).toEqual('Hoge')

    it 'selects the Hoge from the right edge', ->
      editor.moveRight(7)
      editor.selectToBeginningOfWord()
      expect(editor.getSelectedText() ).toEqual('Hoge')

    it 'selects the second ほげ from the left edge', ->
      editor.moveRight(8)
      editor.selectToEndOfWord()
      expect(editor.getSelectedText() ).toEqual('ほげ')

    it 'selects the second ほげ from the middle of it', ->
      editor.moveRight(9)
      editor.selectWordsContainingCursors()
      expect(editor.getSelectedText() ).toEqual('ほげ')

    it 'selects the second Hほげ from the right edge', ->
      editor.moveRight(10)
      editor.selectToBeginningOfWord()
      expect(editor.getSelectedText() ).toEqual('ほげ')

  describe 'ほげ・Hoge・ほげ', ->
    beforeEach ->
      runs ->
        editor.moveToTop()
        editor.moveDown(6)
        editor.moveToBeginningOfLine()

    it 'selects the first ほげ from the left edge', ->
      editor.selectToEndOfWord()
      expect(editor.getSelectedText() ).toEqual('ホゲ')

    it 'selects the first ほげ from the middle of it', ->
      editor.moveRight(1)
      editor.selectWordsContainingCursors()
      expect(editor.getSelectedText() ).toEqual('ホゲ')

    it 'selects the first ほげ from the right edge', ->
      editor.moveRight(2)
      editor.selectToBeginningOfWord()
      expect(editor.getSelectedText() ).toEqual('ホゲ')

    it 'selects the Hoge from the left edge', ->
      editor.moveRight(3)
      editor.selectToEndOfWord()
      expect(editor.getSelectedText() ).toEqual('Hoge')

    it 'selects the Hoge from the middle of it', ->
      editor.moveRight(5)
      editor.selectWordsContainingCursors()
      expect(editor.getSelectedText() ).toEqual('Hoge')

    it 'selects the Hoge from the right edge', ->
      editor.moveRight(7)
      editor.selectToBeginningOfWord()
      expect(editor.getSelectedText() ).toEqual('Hoge')

    it 'selects the second ほげ from the left edge', ->
      editor.moveRight(8)
      editor.selectToEndOfWord()
      expect(editor.getSelectedText() ).toEqual('ホゲ')

    it 'selects the second ほげ from the middle of it', ->
      editor.moveRight(9)
      editor.selectWordsContainingCursors()
      expect(editor.getSelectedText() ).toEqual('ホゲ')

    it 'selects the second Hほげ from the right edge', ->
      editor.moveRight(10)
      editor.selectToBeginningOfWord()
      expect(editor.getSelectedText() ).toEqual('ホゲ')

  describe 'ほげ。Hoge。ほげ', ->
    beforeEach ->
      runs ->
        editor.moveToTop()
        editor.moveDown(7)
        editor.moveToBeginningOfLine()

    it 'selects the first ほげ from the left edge', ->
      editor.selectToEndOfWord()
      expect(editor.getSelectedText() ).toEqual('穂毛')

    it 'selects the first ほげ from the middle of it', ->
      editor.moveRight(1)
      editor.selectWordsContainingCursors()
      expect(editor.getSelectedText() ).toEqual('穂毛')

    it 'selects the first ほげ from the right edge', ->
      editor.moveRight(2)
      editor.selectToBeginningOfWord()
      expect(editor.getSelectedText() ).toEqual('穂毛')

    it 'selects the Hoge from the left edge', ->
      editor.moveRight(3)
      editor.selectToEndOfWord()
      expect(editor.getSelectedText() ).toEqual('Hoge')

    it 'selects the Hoge from the middle of it', ->
      editor.moveRight(5)
      editor.selectWordsContainingCursors()
      expect(editor.getSelectedText() ).toEqual('Hoge')

    it 'selects the Hoge from the right edge', ->
      editor.moveRight(7)
      editor.selectToBeginningOfWord()
      expect(editor.getSelectedText() ).toEqual('Hoge')

    it 'selects the second ほげ from the left edge', ->
      editor.moveRight(8)
      editor.selectToEndOfWord()
      expect(editor.getSelectedText() ).toEqual('穂毛')

    it 'selects the second ほげ from the middle of it', ->
      editor.moveRight(9)
      editor.selectWordsContainingCursors()
      expect(editor.getSelectedText() ).toEqual('穂毛')

    it 'selects the second Hほげ from the right edge', ->
      editor.moveRight(10)
      editor.selectToBeginningOfWord()
      expect(editor.getSelectedText() ).toEqual('穂毛')

  describe 'ほげ「Hoge」ほげ', ->
    beforeEach ->
      runs ->
        editor.moveToTop()
        editor.moveDown(8)
        editor.moveToBeginningOfLine()

    it 'selects the first ほげ from the left edge', ->
      editor.selectToEndOfWord()
      expect(editor.getSelectedText() ).toEqual('ほげ')

    it 'selects the first ほげ from the middle of it', ->
      editor.moveRight(1)
      editor.selectWordsContainingCursors()
      expect(editor.getSelectedText() ).toEqual('ほげ')

    it 'selects the first ほげ from the right edge', ->
      editor.moveRight(2)
      editor.selectToBeginningOfWord()
      expect(editor.getSelectedText() ).toEqual('ほげ')

    it 'selects the Hoge from the left edge', ->
      editor.moveRight(3)
      editor.selectToEndOfWord()
      expect(editor.getSelectedText() ).toEqual('Hoge')

    it 'selects the Hoge from the middle of it', ->
      editor.moveRight(5)
      editor.selectWordsContainingCursors()
      expect(editor.getSelectedText() ).toEqual('Hoge')

    it 'selects the Hoge from the right edge', ->
      editor.moveRight(7)
      editor.selectToBeginningOfWord()
      expect(editor.getSelectedText() ).toEqual('Hoge')

    it 'selects the second ほげ from the left edge', ->
      editor.moveRight(8)
      editor.selectToEndOfWord()
      expect(editor.getSelectedText() ).toEqual('ほげ')

    it 'selects the second ほげ from the middle of it', ->
      editor.moveRight(9)
      editor.selectWordsContainingCursors()
      expect(editor.getSelectedText() ).toEqual('ほげ')

    it 'selects the second Hほげ from the right edge', ->
      editor.moveRight(10)
      editor.selectToBeginningOfWord()
      expect(editor.getSelectedText() ).toEqual('ほげ')

  describe 'hogeホーゲーほげ', ->
    beforeEach ->
      runs ->
        editor.moveToTop()
        editor.moveDown(9)
        editor.moveToBeginningOfLine()

    it 'selects the first ほげ from the left edge', ->
      editor.selectToEndOfWord()
      expect(editor.getSelectedText() ).toEqual('hoge')

    it 'selects the first ほげ from the middle of it', ->
      editor.moveRight(2)
      editor.selectWordsContainingCursors()
      expect(editor.getSelectedText() ).toEqual('hoge')

    it 'selects the first ほげ from the right edge', ->
      editor.moveRight(4)
      editor.selectToBeginningOfWord()
      expect(editor.getSelectedText() ).toEqual('hoge')

    it 'selects the Hoge from the left edge', ->
      editor.moveRight(4)
      editor.selectToEndOfWord()
      expect(editor.getSelectedText() ).toEqual('ホーゲー')

    it 'selects the Hoge from the middle of it', ->
      editor.moveRight(5)
      editor.selectWordsContainingCursors()
      expect(editor.getSelectedText() ).toEqual('ホーゲー')

    it 'selects the Hoge from the right edge', ->
      editor.moveRight(8)
      editor.selectToBeginningOfWord()
      expect(editor.getSelectedText() ).toEqual('ホーゲー')

    it 'selects the second ほげ from the left edge', ->
      editor.moveRight(8)
      editor.selectToEndOfWord()
      expect(editor.getSelectedText() ).toEqual('ほげ')

    it 'selects the second ほげ from the middle of it', ->
      editor.moveRight(9)
      editor.selectWordsContainingCursors()
      expect(editor.getSelectedText() ).toEqual('ほげ')

    it 'selects the second Hほげ from the right edge', ->
      editor.moveRight(10)
      editor.selectToBeginningOfWord()
      expect(editor.getSelectedText() ).toEqual('ほげ')

  describe '□ほげ▼hoge■ホゲ', ->
    beforeEach ->
      runs ->
        editor.moveToTop()
        editor.moveDown(10)
        editor.moveToBeginningOfLine()

    it 'selects the □ from its left edge', ->
      editor.selectToEndOfWord()
      expect(editor.getSelectedText() ).toEqual('□')

    it 'selects the ほげ from its left edge', ->
      editor.moveRight(1)
      editor.selectToEndOfWord()
      expect(editor.getSelectedText() ).toEqual('ほげ')

    it 'selects the ▼ from its left edge', ->
      editor.moveRight(3)
      editor.selectToEndOfWord()
      expect(editor.getSelectedText() ).toEqual('▼')

    it 'selects the hoge from its left edge', ->
      editor.moveRight(4)
      editor.selectToEndOfWord()
      expect(editor.getSelectedText() ).toEqual('hoge')

    it 'selects the ■ from its left edge', ->
      editor.moveRight(8)
      editor.selectToEndOfWord()
      expect(editor.getSelectedText() ).toEqual('■')

    it 'selects the ホゲ from its left edge', ->
      editor.moveRight(9)
      editor.selectToEndOfWord()
      expect(editor.getSelectedText() ).toEqual('ホゲ')
