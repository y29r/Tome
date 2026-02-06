--!strict

--[[

	@param object any
	@return string

	Returns the type of the provided object. If the type of the object is a table
	Then __type of the table will be returned. Elsewise the type "table" is returned.
	
]]
return function(object: any) : string
	local realType = typeof(object)
	
	if realType == "table" and object.__type then
		return object.__type
	end
	
	return realType
end