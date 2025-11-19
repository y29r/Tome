--!strict
-- Author : @y29r (Git)
-- Date : 03(D)/10(M)/2024(Y)

local isEmpty = require("./isEmpty")
local deepCopy = require("./deepCopy")
local reconcile = require("./reconcile")
local stringReconcile = require("./stringReconcile")

local TableUtility = {
	isEmpty = isEmpty,
	deepCopy = deepCopy,
	reconcile = reconcile,
	stringReconcile = stringReconcile,
}

return TableUtility