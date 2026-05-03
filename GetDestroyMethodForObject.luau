--!strict

const Symbol = require("./Symbol/Symbol")

const TweenType: Symbol.Symbol = require("./TweenType")
const ThreadType: Symbol.Symbol = require("./ThreadType")
const FunctionType: Symbol.Symbol = require("./FunctionType")

const throwError = require("./throwError")

--[[

	@param object any
	@return any

	Returns a unique userdata or string to tell the Tome how to go about destroying the provided object
	The provided statements below should be enough for most cases, but if needed pass the second arg of Tome:Add to destroy an object your own way

]]
return function(object: any) : any
	const objectType: string = typeof(object)
	
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
			const metatable: {[string]: any} = getmetatable(object)
			if metatable and metatable.__call then
				return metatable.__call
			end
		end
	end
	
	return throwError(string.format("Attempted to get a destroy method for object '%*', but no destroy method was found.", object),
		"Ensure any objects added into the Tome are destroyable. Or pass a custom destroyer function for the object as the second parameter in Tome:Add")
end