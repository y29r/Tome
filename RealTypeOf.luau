--!strict

return function(object: any) : any
	local realType = typeof(object)
	
	if realType == "table" and object.__type then
		return object.__type
	end
	
	return realType
end