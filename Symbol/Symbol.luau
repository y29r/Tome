--!strict
-- Auth: @bytenand (Roblox) @y29r (Github)
-- Date: December 2nd, 2025
-- Deps: []

const createSymbol = require("./createSymbol")

export type Symbol = createSymbol.Symbol
export type SymbolInternal = createSymbol.SymbolInternal
export type Metatable = createSymbol.Metatable

return {
	createSymbol = createSymbol,
}