--!strict

local function deepCopy(toDeepCopy: {[any]: any}) : {[any]: any}
	local copied = {}
	
	for key, value in toDeepCopy do
		copied[key] = type(value) == "table"
			and deepCopy(value)
			or value
	end
	
	return copied
end

return deepCopy