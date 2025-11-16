--!strict

local Types = require("./Types")
local TweenType = require("./TweenType")
local ThreadType = require("./ThreadType")
local FunctionType = require("./FunctionType")

local THREAD_DEAD_STATE: string = "dead"

return function(object: any, destroyMethod: Types.DestroyMethod) : ()
	if type(destroyMethod) == "function" then
		return destroyMethod(object)
	end
	
	if destroyMethod == FunctionType then
		object()
	elseif destroyMethod == TweenType then
		object:Cancel()
		object:Destroy()
	elseif destroyMethod == ThreadType then
		--TODO: Manage other thread states and perhaps allow for something more flexible and robust
		-- thread states: "dead", "suspended", "normal", "running"
		local threadStatus = coroutine.status(object)
		
		if threadStatus ~= THREAD_DEAD_STATE then
			pcall(task.cancel, object)
		end
	else
		local destroyFunction = object[destroyMethod]
		if destroyFunction then
			pcall(destroyFunction, object)
		end
	end
end