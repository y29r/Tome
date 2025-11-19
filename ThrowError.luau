--!strict

return function(message: string, fix: string?) : ()
	local traceback: string = debug.traceback()
	
	local callStack: {string} = {}
	local splitTraceback: {string} = string.split(traceback, "\n")
	for index: number, line: string in splitTraceback do
		table.insert(callStack, (index == 1 and "" or " ") .. line)
	end
	
	local callHierarchy: string = table.concat(callStack, "\n")
	local fixMessage: string = fix and string.format("\n Potential Fix: '%s'.", fix) or ""
	local errorTemplate: string = string.format("'%s'.%s\n\n Call Hierarchy:\n %s", message, fixMessage, callHierarchy)
	
	error(errorTemplate, 10)
end