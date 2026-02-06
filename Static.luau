--!strict

--[[
	These are constants that are changeable before run time
	Every Tome will start with these static meta props, unless changed
	through passing a meta props table
	
	For secure parsing the recommended props are:
		FastAdd = true
		SpawnDestroy = true,
		Warnings = true,
		Tagging = true,
		UseParentMetaprops = true,
		
	Otherwise if you know what you're doing, and the objects you add
	are safe, use the props below
]]

return {
	FastAdd = true,
	SpawnDestroy = true,
	Warnings = true,
	Tagging = false,
	UseParentMetaprops = true,
}