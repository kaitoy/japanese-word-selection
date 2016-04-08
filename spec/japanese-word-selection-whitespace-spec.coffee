JapaneseWordSelection = require '../lib/japanese-word-selection'

describe 'JapaneseWordSelection with whitespaces', ->
  editor = null

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage('japanese-word-selection')

    waitsForPromise ->
      atom.workspace.open().then (o) -> editor = o

    runs ->
      editor.insertText('''
          ああああﾎｹﾞんんんん
        		アアアア穂毛んんんん
        ああああ	ほげ  んんんん
        ｱｱｱｱhogeんんんん
      ''')

  describe 'Spaces leading Hiragana', ->
    beforeEach ->
      runs ->
        editor.moveToTop()
        editor.moveToBeginningOfLine()

    it 'selects the first Hiragana word from its left edge', ->
      editor.selectToEndOfWord()
      expect(editor.getSelectedText() ).toEqual('  ああああ')

    it 'selects the first Hiragana word from its right edge', ->
      editor.moveRight(6)
      editor.selectToBeginningOfWord()
      expect(editor.getSelectedText() ).toEqual('ああああ')

  describe 'Tabs leading Katakana', ->
    beforeEach ->
      runs ->
        editor.moveToTop()
        editor.moveDown()
        editor.moveToBeginningOfLine()

    it 'selects the first Katakana word from its left edge', ->
      editor.selectToEndOfWord()
      expect(editor.getSelectedText() ).toEqual('		アアアア')

    it 'selects the first Katakana word from its right edge', ->
      editor.moveRight(8)
      editor.selectToBeginningOfWord()
      expect(editor.getSelectedText() ).toEqual('アアアア')

  describe 'Spaces and tabs between words', ->
    beforeEach ->
      runs ->
        editor.moveToTop()
        editor.moveDown(2)
        editor.moveToBeginningOfLine()

    it 'selects the first Hiragana word from its left edge', ->
      editor.selectToEndOfWord()
      expect(editor.getSelectedText() ).toEqual('ああああ')

    it 'selects the Hiragana word between spaces and tabs from the right edge of the first Hiragana', ->
      editor.moveRight(4)
      editor.selectToEndOfWord()
      expect(editor.getSelectedText() ).toEqual('	ほげ')

    it 'selects the last Hiragana word from the left edge of the second Hiragana', ->
      editor.moveRight(8)
      editor.selectToEndOfWord()
      expect(editor.getSelectedText() ).toEqual('  んんんん')

  describe 'Words separated by a new line', ->
    beforeEach ->
      runs ->
        editor.moveToTop()
        editor.moveDown(2)
        editor.moveToEndOfLine()

    it 'selects the half-width Katakana word at the beginning of line from the end of previous line', ->
      editor.selectToEndOfWord()
      expect(editor.getSelectedText() ).toEqual("\nｱｱｱｱ")

    it 'selects the Hiragana word at the end of line from the beginning of next line', ->
      editor.moveDown()
      editor.moveToBeginningOfLine()
      editor.selectToBeginningOfWord()
      expect(editor.getSelectedText() ).toEqual('んんんん\n')
