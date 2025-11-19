--!strict

local deepCopy = require("./deepCopy")

local function reconcile(toReconcile: {[any]: any}, against: {[any]: any}) : {[any]: any}
	for key, value in against do
		local doesntExist = toReconcile[key] == nil
		if doesntExist then
			if type(value) == "table" then
				toReconcile[key] = deepCopy(value)
			else
				toReconcile[key] = value
			end
		end
	end
	
	return toReconcile
end

return reconcile