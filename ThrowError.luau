--!strict

--[[

	@param message string
	@param fix string?
	@return void

	Forcefully throws an error to the output using a prettier formatting.
	An optional fix argument can be passes to let writers potentially understand why something isn't working
	
]]
return function(message: string, fix: string?) : any
	const traceback: string = debug.traceback()
	
	const callStack: {string} = {}
	const splitTraceback: {string} = string.split(traceback, "\n")
	for index: number, line: string in splitTraceback do
		table.insert(callStack, (index == 1 and "" or " ") .. line)
	end
	
	const callHierarchy: string = table.concat(callStack, "\n")
	const fixMessage: string = fix and string.format("\n Potential Fix: '%s'.", fix) or ""
	const errorTemplate: string = string.format("'%s'.%s\n\n Call Hierarchy:\n %s", message, fixMessage, callHierarchy)
	
	error(errorTemplate, 10)
end