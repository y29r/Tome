--!strict

local TweenType = require("./TweenType")
local ThreadType = require("./ThreadType")
local ThrowError = require("./ThrowError")
local FunctionType = require("./FunctionType")

-- an easy object remover function which returns what function to call on the object itself
-- for custom removal such as promises, using a function for the second argument of :Add should be used,
-- otherwise it may be a better idea to edit the code below to adjust on how to destroy the custom object.
return function(object: any) : any
	local objectType = typeof(object)
	
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
		end
	end
	
	return ThrowError(string.format("Attempted to get a destroy method for object '%s', but no destroy method was found.", tostring(object)),
		"Ensure any objects added into the Tome are destroyable. Or pass a custom destroyer function for the object as the second parameter in Tome:Add")
end