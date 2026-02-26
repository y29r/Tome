--!strict

local TweenType = require("./TweenType")
local ThreadType = require("./ThreadType")
local FunctionType = require("./FunctionType")

local throwError = require("./throwError")

--[[

	@param object any
	@return any

	Returns a unique userdata or string to tell the Tome how to go about destroying the provided object
	The provided statements below should be enough for most cases, but if needed pass the second arg of Tome:Add to destroy an object your own way

]]
return function(object: any) : any
	local objectType: string = typeof(object)
	
	if objectType == "Instance" then
		if object:IsA("Tween") then
			return TweenType
		else
			return "Destroy"
		end
	elseif objectType == "function" then
		return FunctionType
	elseif objectType == "thread" then
		return ThreadType
	elseif objectType == "RBXScriptConnection" then
		return "Disconnect"
	elseif objectType == "table" then
		if type(object.Destroy) == "function" then
			return "Destroy"
		elseif type(object.Disconnect) == "function" then
			return "Disconnect"
		elseif type(object.destroy) == "function" then
			return "destroy"
		else
			local metatable: {[string]: any} = getmetatable(object)
			if metatable and metatable.__call then
				return metatable.__call
			end
		end
	end
	
	return throwError(string.format("Attempted to get a destroy method for object '%s', but no destroy method was found.", tostring(object)),
		"Ensure any objects added into the Tome are destroyable. Or pass a custom destroyer function for the object as the second parameter in Tome:Add")
end