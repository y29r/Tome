--!strict

local Symbol = {}

function Symbol.new(name: string) : any
	local proxy: any = newproxy(true)
	local newSymbol: any = getmetatable(proxy)
	
	newSymbol.__tostring = function()
		return string.format("Symbol(%*)", name)
	end
	
	return proxy
end

return Symbol