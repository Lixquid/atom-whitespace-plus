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

	describe "'whitespace-plus:smart-convert'", ->

		describe "when the target is Soft:2", ->

			beforeEach ->
				atom.config.set( "editor.softTabs", true )
				atom.config.set( "editor.tabLength", 2 )

			it "correctly converts hard tabbed text", ->
				editor.setText( """
					0
						1
						1
							2
				""" )

				exec( "whitespace-plus:smart-convert" )

				expect( editor.getText() ).toBe( """
					0
					  1
					  1
					    2
				""" )
				expect( editor.getSoftTabs() ).toBe( true )
				expect( editor.getTabLength() ).toBe( 2 )

			it "correctly converts soft tabbed text of a different length", ->
				editor.setText( """
					0
					    1
					    1
					        2
				""" )

				exec( "whitespace-plus:smart-convert" )

				expect( editor.getText() ).toBe( """
					0
					  1
					  1
					    2
				""")

			it "does nothing to correctly indented text", ->
				editor.setText( """
					0
					  1
					  1
					    2
					        4
				""")

				exec( "whitespace-plus:smart-convert" )

				expect( editor.getText() ).toBe( """
					0
					  1
					  1
					    2
					        4
				""" )

		describe "when the target is Hard:4", ->

			beforeEach ->
				atom.config.set( "editor.softTabs", false )
				atom.config.set( "editor.tabLength", 4 )

			it "correctly converts soft tabbed text of length 2", ->
				editor.setText( """
					0
					  1
					  1
					      3
				""" )

				exec( "whitespace-plus:smart-convert" )

				expect( editor.getText() ).toBe( """
					0
						1
						1
								3
				""")
				expect( editor.getSoftTabs() ).toBe( false )
				expect( editor.getTabLength() ).toBe( 4 )

			it "correctly converts soft tabbed text of length 4", ->
				editor.setText( """
					0
					    1
					    1
					            3
				""" )

				exec( "whitespace-plus:smart-convert" )

				expect( editor.getText() ).toBe( """
					0
						1
						1
								3
				""")

			it "does nothing to correctly indented text", ->
				editor.setText( """
					0
						1
						1
								3
				""" )

				exec( "whitespace-plus:smart-convert" )

				expect( editor.getText() ).toBe( """
					0
						1
						1
								3
				""")

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
