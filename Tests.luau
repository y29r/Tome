--!strict
--!native
-- Auth: @y29r
-- Date: 24/04/2026
-- Deps: []

-- Helper for unit testing more complex edge cases for new and existing methods

const Tome = require("./Tome")

const Tests = {}
const Expectations: {[string]: () -> boolean} = {}

Tests.Expectations = Expectations

function Tests.testAll() : boolean
	for expectationName: string, expectationFunction: () -> boolean in Expectations do
		local success: boolean = expectationFunction()
		if not success then
			return false
		end
	end
	
	return true
end

function Expectations.expectNew() : boolean
	local tome: Tome.Tome? = Tome.new()
	
	return tome ~= nil
end

function Expectations.expectAdd() : boolean
	local tome: Tome.Tome = Tome.new()
	
	local part: Part = Instance.new("Part")
	part.Parent = workspace
	
	tome:Add(part)
	
	return true
end

-- TODO: Add more unit tests

return Tests