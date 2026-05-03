--!strict
-- Auth: @bytenand (Roblox) @y29r (Github)
-- Date: December 2nd, 2025
-- Deps: []

const metatable: Metatable = {
	__tostring = function(self: Symbol)
		return string.format("%*(%*)", self.wrapperName, self.name)
	end
}

export type Metatable = {
	__tostring: (Symbol) -> string
}

export type SymbolInternal = {
	name: string,
	wrapperName: string,
}

-- TODO: Replace with setmetatable<T, U> once the new solver releases
export type Symbol = typeof(setmetatable({} :: SymbolInternal, metatable))

--[[
	
	@param name string
	@return {}
	
	Creates a new symbol, when tostring()ed will convert the given name
	Useful for sample Enumerators or envisioning data easier
	
]]
return function(name: string, wrapperName: string?) : Symbol
	return setmetatable({
		name = name,
		wrapperName = wrapperName or "Symbol"
	}, metatable)
end