describe "Whitespace Plus", ->

	editor = null
	editor_view = null

	exec = ( command ) ->
		atom.commands.dispatch( editor_view, command )

	beforeEach ->
		waitsForPromise ->
			atom.packages.activatePackage( "whitespace-plus" )

		waitsForPromise ->
			atom.workspace.open()

		runs ->
			editor = atom.workspace.getActiveTextEditor()
			editor_view = atom.views.getView( editor )

	describe "'whitespace-plus:convert-x-spaces-to-tabs'", ->

		it "converts the right number of spaces to tabs", ->
			editor.setText( """
				0
				  1
				  1
				    2
			""" )
			exec( "whitespace-plus:convert-2-spaces-to-tabs" )
			expect( editor.getText() ).toBe( """
				0
					1
					1
						2
			""" )

		it "can convert differing lengths of spaces to tabs", ->
			editor.setText( """
				0
				    1
				    1
				        2
			""" )
			exec( "whitespace-plus:convert-4-spaces-to-tabs" )
			expect( editor.getText() ).toBe( """
				0
					1
					1
						2
			""" )

		it "does not convert spaces that are not indentation", ->
			editor.setText( """
				0  0  0
				  1  1
			""" )
			exec( "whitespace-plus:convert-2-spaces-to-tabs" )
			expect( editor.getText() ).toBe( """
				0  0  0
					1  1
			""" )

		it "converts a discrete number of spaces", ->
			editor.setText( """
				0
				  1
				  1
				   1
				    2
				    2
			""" )
			exec( "whitespace-plus:convert-2-spaces-to-tabs" )
			expect( editor.getText() ).toBe( """
				0
					1
					1
					 1
						2
						2
			""" )

	describe "'whitespace-plus:convert-tabs-to-x-spaces'", ->

		it "converts tabs to the right number of spaces", ->
			editor.setText( """
				0
					1
					1
						2
			""" )
			exec( "whitespace-plus:convert-tabs-to-2-spaces" )
			expect( editor.getText() ).toBe( """
				0
				  1
				  1
				    2
			""" )

		it "can convert tabs to differing lengths of spaces", ->
			editor.setText( """
				0
					1
					1
						2
			""" )
			exec( "whitespace-plus:convert-tabs-to-4-spaces" )
			expect( editor.getText() ).toBe( """
				0
				    1
				    1
				        2
			""" )

		it "does not convert spaces that are not indentation", ->
			editor.setText( """
				0  	0	0
					1	1
			""" )
			exec( "whitespace-plus:convert-tabs-to-2-spaces" )
			expect( editor.getText() ).toBe( """
				0  	0	0
				  1	1
			""" )
