--!strict
-- Auth: @bytenand (Roblox) @y29r (Github)
-- Date: December 2nd, 2025
-- Deps: []

local metatable: {__tostring: ({name: string, wrapperName: string}) -> string} = {
	__tostring = function(self: {name: string, wrapperName: string})
		return string.format("%*(%*)", self.wrapperName, self.name)
	end
}

--[[
	
	@param name string
	@return {}
	
	Creates a new symbol, when tostring()ed will convert the given name
	Useful for sample Enumerators or envisioning data easier
	
]]
local function createSymbol(name: string, wrapperName: string?) : {name: string}
	local proxy: any = {}
	proxy.name = name
	proxy.wrapperName = wrapperName or "Symbol"
	
	setmetatable(proxy, metatable)
	
	return proxy
end

return createSymbol