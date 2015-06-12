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

	describe "'whitespace-plus.changeIndentStyleOnConvert'", ->

		describe "when true", ->

			beforeEach ->
				atom.config.set( "whitespace-plus.changeIndentStyleOnConvert", true )

			it "modifies the indentation style of the editor for spaces", ->
				editor.setText( """
					0
					  1
					  1
				""" )
				editor.setSoftTabs( true )
				editor.setTabLength( 2 )

				exec( "whitespace-plus:convert-2-spaces-to-tabs" )

				expect( editor.getText() ).toBe( """
					0
						1
						1
				""" )
				expect( editor.getSoftTabs() ).toBe( false )

			it "modifies the indentation styles of the editor for tabs", ->
				editor.setText( """
					0
						1
						1
				""" )
				editor.setSoftTabs( false )

				exec( "whitespace-plus:convert-tabs-to-2-spaces" )

				expect( editor.getText() ).toBe( """
					0
					  1
					  1
				""" )
				expect( editor.getSoftTabs() ).toBe( true )
				expect( editor.getTabLength() ).toBe( 2 )

		describe "when false", ->

			beforeEach ->
				atom.config.set( "whitespace-plus.changeIndentStyleOnConvert", false )

			it "does not modify the indentation style of the editor for tabs", ->
				editor.setText( """
					0
					  1
					  1
				""" )
				editor.setSoftTabs( true )
				editor.setTabLength( 2 )

				exec( "whitespace-plus:convert-2-spaces-to-tabs" )

				expect( editor.getText() ).toBe( """
					0
						1
						1
				""" )
				expect( editor.getSoftTabs() ).toBe( true )
				expect( editor.getTabLength() ).toBe( 2 )

			it "does not modify the indentation styles of the editor for spaces", ->
				editor.setText( """
					0
						1
						1
				""" )
				editor.setSoftTabs( false )
				editor.setTabLength( 4 )

				exec( "whitespace-plus:convert-tabs-to-2-spaces" )

				expect( editor.getText() ).toBe( """
					0
					  1
					  1
				""" )
				expect( editor.getSoftTabs() ).toBe( false )
				expect( editor.getTabLength() ).toBe( 4 )
