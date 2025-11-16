--!strict

local deepCopy = require("./deepCopy")

local function stringReconcile(toReconcile: {[any]: any}, against: {[any]: any}) : {[any]: any}
	for key, value in against do
		if type(key) ~= "string" then
			continue
		end
		
		local toReconcileKeyValue = toReconcile[key]
		local doesntExist = toReconcileKeyValue == nil
		if doesntExist then
			if type(value) == "table" then
				toReconcile[key] = deepCopy(value)
			else
				toReconcile[key] = value
			end
		elseif type(toReconcileKeyValue) == "table" and type(value) == "table" then
			stringReconcile(toReconcileKeyValue, value)
		end
	end
	
	return toReconcile
end

return stringReconcile