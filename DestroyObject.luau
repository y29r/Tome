--!strict

const Types = require("./Types")

const TweenType = require("./TweenType")
const ThreadType = require("./ThreadType")
const FunctionType = require("./FunctionType")

const THREAD_DEAD_STATE: string = "dead"

--[[

	@param object any
	@param destroyMethod Types.DestroyMethod
	@return void

	Destroys the provide object with the given destroy method.
	If a function is used as the destroy method, it will call itself inside a safe scope and pass the object as the first argument
	
]]
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
		const threadStatus: "dead" | "normal" | "running" | "suspended" = coroutine.status(object)
		
		if threadStatus ~= THREAD_DEAD_STATE then
			pcall(task.cancel, object)
		end
	else
		const destroyFunction: ((object: any) -> ())? = object[destroyMethod]
		if destroyFunction then
			pcall(destroyFunction, object)
		end
	end
end