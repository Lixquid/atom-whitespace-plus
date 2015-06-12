## Dependencies ################################################################

IndentationConverter = require "./indentation-converter"

## Package #####################################################################

module.exports = WhitespacePlus =

	## Config ##################################################################

	config:
		changeIndentStyleOnConvert:
			type: "boolean"
			default: true
			description: "If true, the editor will automatically switch to a new
				indentation style when a conversion command is run."

	## Fields ##################################################################

	converter: null

	## Activator / Deactivator #################################################

	activate: ->
		@converter = new IndentationConverter

	deactivate: ->
		@converter.destroy()
