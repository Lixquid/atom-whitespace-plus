## Dependencies ################################################################

{ CompositeDisposable } = require 'atom'

## Class #######################################################################

module.exports = class IndentationConverter

	## Fields ##################################################################

	events: null

	## Constructor / Destructor ################################################

	constructor: ->
		@events = new CompositeDisposable
		@events.add( atom.commands.add( "atom-text-editor", {
			"whitespace-plus:convert-tabs-to-1-space": =>
				@editorConvertToSpaces( 1 )
			"whitespace-plus:convert-tabs-to-2-spaces": =>
				@editorConvertToSpaces( 2 )
			"whitespace-plus:convert-tabs-to-3-spaces": =>
				@editorConvertToSpaces( 3 )
			"whitespace-plus:convert-tabs-to-4-spaces": =>
				@editorConvertToSpaces( 4 )
			"whitespace-plus:convert-tabs-to-6-spaces": =>
				@editorConvertToSpaces( 6 )
			"whitespace-plus:convert-tabs-to-8-spaces": =>
				@editorConvertToSpaces( 8 )
			"whitespace-plus:convert-1-space-to-tabs": =>
				@editorConvertToTabs( 1 )
			"whitespace-plus:convert-2-spaces-to-tabs": =>
				@editorConvertToTabs( 2 )
			"whitespace-plus:convert-3-spaces-to-tabs": =>
				@editorConvertToTabs( 3 )
			"whitespace-plus:convert-4-spaces-to-tabs": =>
				@editorConvertToTabs( 4 )
			"whitespace-plus:convert-6-spaces-to-tabs": =>
				@editorConvertToTabs( 6 )
			"whitespace-plus:convert-8-spaces-to-tabs": =>
				@editorConvertToTabs( 8 )
			"whitespace-plus:smart-convert": =>
				@editorSmartConvert()
		} ) )

	destroy: ->
		@events.dispose()

	## Conversion Functions ####################################################

	editorConvertToSpaces: ( length ) ->
		editor = atom.workspace.getActiveTextEditor()
		buffer = editor?.getBuffer()
		if not buffer?
			return

		# Replace Indentation
		regex = /^(\t)+/g
		buffer.scan( regex, ( res ) ->
			if not res.match[0]?
				return

			target = res.match[0].length * length + 1
			res.replace( new Array( target ).join( ' ' ) )
		)

		# Change Editor Indentation style
		if atom.config.get( "whitespace-plus.changeIndentStyleOnConvert" )
			editor.setSoftTabs( true )
			editor.setTabLength( length )

	editorConvertToTabs: ( length ) ->
		editor = atom.workspace.getActiveTextEditor()
		buffer = editor?.getBuffer()
		if not buffer?
			return

		# Replace Indentation
		regex = new RegExp(
			"^(" + new Array( length + 1 ).join( ' ' ) + ")+", 'g'
		)
		buffer.scan( regex, ( res ) ->
			if not res.match[0]?
				return

			target = res.match[0].length // length + 1
			res.replace( new Array( target ).join( '\t' ) )
		)

		# Change Editor Indentation style
		if atom.config.get( "whitespace-plus.changeIndentStyleOnConvert" )
			editor.setSoftTabs( false )
			editor.setTabLength( atom.config.get(
			  "editor.tabLength",
			  { scope: [ editor.getGrammar().scopeName ] }
			) )

	editorSmartConvert: ->
		editor = atom.workspace.getActiveTextEditor()
		if not editor?
			return

		scope_arg = { scope: [ editor.getGrammar().scopeName ] }
		target_len = atom.config.get( "editor.tabLength", scope_arg )
		target_tab = atom.config.get( "editor.softTabs", scope_arg )

		# Convert Text
		current_style = @editorGetIndentation()
		if current_style?
			if current_style # Soft Tabs
				@editorConvertToTabs( current_style )
			if target_tab
				@editorConvertToSpaces( target_len )

		# Change editor settings
		editor.setSoftTabs( target_tab )
		editor.setTabLength( target_len )

	## Utility Functions #######################################################

	editorGetIndentation: ->
		editor = atom.workspace.getActiveTextEditor()
		buffer = editor?.getBuffer()
		tokenized_buffer = editor?.displayBuffer.tokenizedBuffer
		if not buffer? or not tokenized_buffer?
			return

		for row in [ 0 .. buffer.getLastRow() ]
			# Ignore comments
			if tokenized_buffer.tokenizedLineForRow( row ).isComment()
				continue

			line = buffer.lineForRow( row )
			if line.indexOf( '\t' ) == 0
				return false

			if line.indexOf( ' ' ) == 0
				return line.match( /^ +/ )[0].length

		return undefined
