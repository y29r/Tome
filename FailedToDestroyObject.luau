--!strict

--[[

	@param object any
	@param result any
	@return void

	Throws a warning if the provided object could not be destroyed.
	If the provided object is a table, and also contains a __tostring metamethod, then return a different message
	This is in rarer cases where objects use a different way to stingify themselves
	
]]
return function(object: any, result: any) : ()
	if type(object) == "table" then
		local metatable: any = getmetatable(object)
		if metatable and type(metatable.__tostring) == "function" then
			return warn([[
				Provided object destroy failure could not be printed because its __tostring metamethod has been binded.
				For this message to appear the object must be a table. Ensure the table has a standard clean up method
				like :Destroy(). If you have a custom destroy method, parse it as the second argument of Tome:Add(object, "METHOD")
			]])
		end
	end
	
	return warn(string.format([[
		Attempted and failed to destroy object: %s.
		Following error message: %s
	]], object, result))
end