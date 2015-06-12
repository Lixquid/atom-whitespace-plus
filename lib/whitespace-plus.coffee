{ CompositeDisposable } = require 'atom'

module.exports = WhitespacePlus =

	## Fields ##################################################################

	events: null

	## Acivator / Deactivator ##################################################

	activate: ->
		# Register Command event handlers
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
		} ) )

	deactivate: ->
		@events.dispose()

	## Conversion Functions ####################################################

	editorConvertToSpaces: ( length ) ->
		buffer = atom.workspace.getActiveTextEditor()?.getBuffer()
		if not buffer?
			return

		regex = /^(\t)+/g
		buffer.scan( regex, ( res ) ->
			if not res.match[0]?
				return

			target = res.match[0].length * length + 1
			res.replace( new Array( target ).join( ' ' ) )
		)

	editorConvertToTabs: ( length ) ->
		buffer = atom.workspace.getActiveTextEditor()?.getBuffer()
		if not buffer?
			return

		regex = new RegExp(
			"^(" + new Array( length + 1 ).join( ' ' ) + ")+", 'g'
		)
		buffer.scan( regex, ( res ) ->
			if not res.match[0]?
				return

			target = res.match[0].length // length + 1
			res.replace( new Array( target ).join( '\t' ) )
		)
