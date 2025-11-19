--!strict
--!native
-- Author : @y29r (Git)
-- Date : 03(D)/10(M)/2024(Y)
--[[
	Dependencies:
		- Signal (only v1.2a-7 and below)
		- TableUtility (only v1.2a-7 and below)
		- Symbol (only v1.2a-7 and below)
]]
-- A basic clean up module to handle Instances, custom classes and function clean ups.
--[[
	v1.2.c-2:
		Fixed a few typos with types
		Unburrowed the modules under Tome to be inside the primary folder
		Tome:UnsafeAdd removed
		Tome:FastAdd added - acts just like Tome:UnsafeAdd as an alias
		Added a VERSION module under Tome which can also be read with Tome.version
		
	v1.2.c-1:
		Tome.Types has been added which now covers all the types for the Tome
		Tome has a few minor additions and improvements aross a few methods
		
	v1.2.b-9:
		Tome:Connect only allows signals that have :Connect defined within them
			Aliases such as :connect or :Subscribe aren't allowed
		
	v1.2.b-8:
		Changed Tome:Connect signal argument to 'any' type
		
	v1.2.b-7:
		Removed strict behaviour for Tome; may be changed in the near future
		
		Fixed more issues related to Tome:AddPage
		
	v1.2.b-6:
		Released a hotfix for an issue with Tome:AddPage
		
	v1.2.b-5:
		Renamed 'metadata' to 'metaprops' to match newer content
		
		Tome:AddPage can now take in an optional argument 'metaprops'
		
		Added a new metaprop 'UseParentMetaprops':
			When set to true (currently the Static default) any pages created under the Tome that has it, will have the same metaprops
		
	v1.2.b-4:
		Added Static.luau:
			Tome will now default its meta props to what Static has within it.
			
		Fixed typos within Tome:Clone
		Added an 'extendFunctionName' argument into Tome:Clone:
			Passing this argument will instate the object using that as the function to invoke once indexed
		
		Minor optimizations
		
		Added Tome:UnsafeAdd for NON-PROD envs:
			Will add an object into the Tome while bypassing all sanity checks
		
	v1.2.b-3:
		Fixed types for:
			Tome:Spawn
			Tome:Delay
			Tome:Defer
			
			```lua
			local function foo(bar: string) : string
				return bar
			end
			
			Tome:Spawn(foo, "bar") --> will now not throw a type error
			```
			
	v1.2.b-2:
		Added Tome:Table - See below for more details
		
	v1.2.b-1:
		Added 'Symbol' as a new dependency
		Added Tome.ClearTable as a destroy type
			You can now parse Tome.ClearTable when providing a table through Tome:Add
			
			Tome:Add(myTable, Tome.ClearTable)
			
			This property will clear the given table when the Tome is destroyed. It is useful
			for when you may want to clear a table of instances, which are hard referenced;
			freeing up unnecessary used memory.
			
		Dependency fixes for external use
		
	v1.2.a-9:
		Patched a dependency issue created after v1.2.a-8
		All object removal methods now return the object:
			Tome:Remove<Object>(object: Object) : Object
			Tome:RemoveTuple<Object...>(...: Object...) : (Object...)
			Tome:RemoveFromArray<objectArray>(objectArray: objectArray) : objectArray
			
		Type inference for the following methods now exist:
			Tome:Add<Object>(object: Object) -> Object
			Tome:AddTuple<Object...>(...: Object...) : (Object...)
			Tome:AddFromArray<objectArray>(objectArray: objectArray) : objectArray
			Tome:Move<Object>(object: Object, ...) : Object
			Tome:Remove<Object>(object: Object) : Object
			Tome:RemoveTuple<Object...>(...: Object...) : (Object...)
			Tome:RemoveFromArray<objectArray>(objectArray: objectArray) : objectArray
		Fixed typos across methods
		Replaced method documentation for changed methods
		
	v1.2.a-8:
		Moved dependencies inside Tome for easier external use
		
	v1.2.a-7:
		Added author and date created stamps
		Created a the internal 'fetchDependency' function which helps debug dependencies which may not exist
	
	v1.2a-6:
		Moved internal functions outside of Tome for future edits
		Added a dependency list as Tome now relies on a few to run properly
		
	Before invoking a method, read the summary of it - located above every method respectively.
	
	Tome.new : Instantiates a new Tome.
	
	Tome:Add : Adds an object to the Tome.
	Tome:AddTuple : Adds multiple objects to the Tome.
	Tome:AddFromArray : Adds objects from a provided array to the Tome.
	Tome:AddPromise : Adds a standard Promise to the Tome.
	Tome:AddPage : Constructs a Page (alias for Tome) and adds it to the Tome.
	Tome:Attach : Attaches an instance destroying signal to the Tome.
	Tome:BindRenderStepped : Binds to the RunService:BindToRenderStep method.
	Tome:CanDestroy : Returns whether the Tome can be destroyed or not.
	Tome:Clone : Clones an object and adds it to the Tome.
	Tome:Connect : Connects a function to a Signal and adds the connection to the Tome.
	Tome:Once : Connects a function to a Signal once and adds the connection to the Tome.
	Tome:Construct : Constructs a custom class and adds it to the Tome.
	Tome:Delay : Delays a function with task.delay and adds it to the Tome.
	Tome:extend : Alias for Tome:AddPage.
	Tome:Extend : Alias for Tome:AddPage.
	Tome:Spawn : Spawns a function with task.spawn and adds it to the Tome.
	Tome:Defer : Defers a function with task.defer and adds it to the Tome.
	Tome:DelayDestroy : Destroys the Tome after the specified duration.
	Tome:Destroy : Destroys the Tome.
	Tome:DestroyAllObjects : Destroys all the objects contained within the Tome.
	Tome:DestroyAllPages : Destroys all the Pages contained within the Tome.
	Tome:DestroyObject : Destroys the provided object if it exists within the Tome.
	Tome:DestroyObjects : Destroys the provided objects if they exists within the Tome.
	Tome:DestroyObjectsWithTag : Destroys all the objects in the Tome that have the specified tag.
	Tome:DestroyObjectsOfClass : Destroys all the objects in the Tome that have the specified class name.
	Tome:Find : Returns whether the specified object exists within the Tome.
	Tome:Has : Alias for Tome:Find.
	Tome:FromExisting : Creates an Instance with Instance.fromExisting and adds it to the Tome.
	Tome:GetObjects : Returns all the objects contained within the Tome.
	Tome:GetObjectsWithTag : Returns all the objects contained within the Tome that contain a provided tag.
	TOme:GetObjectsOfClass : Returns all the objects of a specified class name.
	Tome:GetPage : Returns a Page from the Tome given a name.
	Tome:GetParentTome : Gets the parent Tome (if it has one)
	Tome:GetTag : Returns the internal tag the Tome uses to automatically remove destroyed instances.
	Tome:GivePage : Moves a Page to another Tome or Page.
	Tome:Heartbeat : Connects to the RunService.Heartbeat Signal and adds it to the Tome.
	Tome:Instance : Creates an Instance with Instance.new and adds it to the Tome.
	Tome:IsDestroying : Returns whether the Tome is currently destroying or not.
	Tome:Move : Moves an object from the current Tome to another.
	Tome:Parent : Parents the Tome to another Tome.
	Tome:Remove : Removes an object from the Tome (not destroying it)
	Tome:RemoveTuple : Removes multiple objects from the Tome.
	Tome:RemoveFromArray : Removes objects from an array of objects from the Tome.
	Tome:RemoveObjectsWithTag : Removes objects with a specified tag from the Tome.
	Tome:RemoveObjectsOfClass : Removes objects of a specified class from the Tome.
	Tome:Rename : Renames the Tome.
	Tome:RenderStepped : Connects to the RunService.RenderStepped Signal and adds it to the Tome.
	Tome:RipPage : Destroys the provided page and removes it from the Tome.
	Tome:RipPages : Destroys and removes all the Pages within a Tome.
	Tome:SetTag : Overrides the default Tome tag used for Instances.
	Tome:Signal : Constructs a standard Signal class and adds it to the Tome.
	Tome:UnbindRenderStepped : Unbinds a binding made with Tome:BindRenderStepped.
	Tome:Tween : Tweens an object and adds the Tween to the Tome.
	Tome:Table : Adds a table inside the Tome using Tome.ClearTable as the destroy method.
	Tome:OnDestroy : Attaches a callback that listens for when the Tome destroys.
	
	Standard supported objects:
		[thread] = task.cancel(thread)
		[Instance] = Instance:Destroy()
		[RBXScriptConnection] = Connection:Disconnect()
		[Class] = Class:Destroy() / Class:Disconnect()
		[Tween] = Tween:Cancel(), Tween:Destroy()
		[function] = function()
	
	Tome tagging and how it works:
		Tome tagging is a system that uses CollectionService to clear any references of an object after it
		has been destroyed by something other than the Tome. The system works automatically unless disabled
		by setting the 'Tagging' property to false in the metaprops at instantiation.
	
	Tome metaprops and how to use them:
		Metaprops is an abbreviation for meta properties. Metaprops are what actually change the Tome.
		
		Metaprops is a table that can be passed when constructing a Tome. Metaprops modifies how the
		Tome works. For example, the 'Fast' metaprop will ignore specific statements which results in much
		greater method speeds. See below for a list of metaprops:
		
			'Fast' : boolean : Increases the speed of the Tome:Add method significantly. (Between 10-200 times faster)
			'FastDestroy' : boolean : Calls the destroy method of every object in a new thread; essentially multithreading.
			'Warnings' : boolean : Whether warnings will appear in the output. Errors will not be affected.
			'Tagging' : boolean : Whether to use the tagging system for Instances.
			'Mode' : string : If specified, the objects table will use a metatable with the __mode set to the provided mode. Either "keys", "values", "paired" or "none".
			'UseParentMetaprops' : boolean : If this prop is true, all Pages created under the Tome will automatically define the same metaprops as its parent
				This includes deeply nested Tomes with more complex architecture.
		
		Warnings:
			Setting the Mode metaprop to one of the available values may result in unfavourable results as weak keys/values
			can be difficult to work with. It's recommended to not set this property unless you know what you're doing.
		
]]

local Types = require("./Types")

local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local CollectionService = game:GetService("CollectionService")

local Static = require("./Static")

-- need to explicitly define the error message itself as the type, or string.format complains
local TOME_IS_DESTROYING_ERROR_MESSAGE: "Attempted to '%s' while the current Tome is in the middle of being destroyed."
	= "Attempted to '%s' while the current Tome is in the middle of being destroyed."

-- extension method names for classes that may be called on
local EXTENSION_METHOD_NAMES: {string} = { "clone", "Clone", "extend", "Extend" }

local function fetchDependency(dependencyPath: string, dependencyName: string) : (boolean, any)
	local successfullyFetchedDependency, dependency = pcall(function()
		return (require)(dependencyPath)
	end)
	if not successfullyFetchedDependency then
		warn(string.format([[
		Tome: The dependency '%*' must be installed for Tome to run properly.
		For more information take a look at the dependencies that Tome needs.
		
		Issue: %*
	]], dependencyName, dependency))
	end
	
	return successfullyFetchedDependency, dependency
end

local _signalExists, Signal = fetchDependency("./Signal/Signal", "Signal")
local _tableUtilityExists, TableUtility = fetchDependency("./TableUtility/TableUtility", "TableUtility")

local ThrowError = require("./ThrowError")
local RealTypeOf = require("./RealTypeOf")
local DestroyObject = require("./DestroyObject")
local GetDestroyMethodForObject = require("./GetDestroyMethodForObject")
local FailedToDestroyObject = require("./FailedToDestroyObject")

local Tome = {}
Tome.__index = Tome
Tome.__type = "Tome"

Tome.version = require("./VERSION")

--[[
	
	Tome.new(metadata: TomeMetaprops?) : Tome
	
	Constructs and returns a new Tome object.
	
	```lua
	local Tome = require(`Path`)
	local someTome = Tome.new()
	
	-- add a cube to the new Tome
	someTome:Add(workspace.Cube)
	
	-- destroys the Tome as well as the cube
	someTome:Destroy()
	```
	
]]
local DEFAULT_FAST = Static.Fast
local DEFAULT_FAST_DESTROY = Static.FastDestroy
local DEFAULT_WARNINGS = Static.Warnings
local DEFAULT_TAGGING = Static.Tagging
local DEFAULT_USE_PARENT_METAPROPS = Static.UseParentMetaprops
function Tome.new(metaprops: Types.Metaprops?) : Types.Tome
	local FAST: boolean? = metaprops and metaprops.Fast
	local TAGGING: boolean? = metaprops and metaprops.Tagging
	local WARNINGS: boolean? = metaprops and metaprops.Warnings
	local FAST_DESTROY: boolean? = metaprops and metaprops.FastDestroy
	local USE_PARENT_METAPROPS: boolean? = metaprops and metaprops.UseParentMetaprops
	
	local self = setmetatable({
		__fast = if type(FAST) == "boolean" then FAST else DEFAULT_FAST,
		__fastDestroy = if type(FAST_DESTROY) == "boolean" then FAST_DESTROY else DEFAULT_FAST_DESTROY,
		__warnings = if type(WARNINGS) == "boolean" then WARNINGS else DEFAULT_WARNINGS,
		__tagging = if type(TAGGING) == "boolean" then TAGGING else DEFAULT_TAGGING,
		__pages = {},
		__objects = {},
		__destroying = false,
		__name = nil,
		__parentTome = nil,
		__useParentMetaprops = if type(USE_PARENT_METAPROPS) == "boolean" then USE_PARENT_METAPROPS else DEFAULT_USE_PARENT_METAPROPS,
		__tomeTag = (TAGGING and HttpService:GenerateGUID(false)) or nil,
		__tagRemovedConnection = nil,
		__destroyCallbacks = {},
	}, Tome) :: any
	
	return self :: Types.Tome
end

--[[
	
	Tome:SetTag(tag: string) : Tome
	
	Overrides the tome tag and updates any instances with the original tag. This doesn't serve much purpose, but
	perhaps in the future it may.
	
]]
function Tome:SetTag(tag: string) : Types.Tome
	assert(type(tag) == "string", "Tome:SetTag tag argument must be a string type.")
	
	local oldTag: string? = self:GetTag()
	if oldTag then
		for index, instance in CollectionService:GetTagged(oldTag) do
			instance:RemoveTag(oldTag)
			instance:AddTag(tag)
		end
	end
	
	self.__tomeTag = tag
	
	return self
end

--[[
	
	Tome:GetTag() : string?
	
	Returns the tag the Tome uses to remove referenced instances. Typically this is only used
	internally, but this may come in helpful within the future.
	
]]
function Tome:GetTag() : string?
	return self.__tomeTag
end

--[[
	
	Tome:__connectTagRemoved() : ()
	
	An internal method used to bind the "tag removed" connection. This method
	shouldn't be called outside this scope.
	
]]
function Tome:__connectTagRemoved() : ()
	local tagRemovedConnection: RBXScriptConnection? = self:__getTagRemovedConnection()
	if tagRemovedConnection then
		return
	end
	
	local tomeTag: string? = self:GetTag()
	if not tomeTag then
		return
	end
	
	local function instanceRemoved(instance: Instance)
		self.__objects[instance] = nil
		
		local objectExists: {Instance} = CollectionService:GetTagged(tomeTag)
		if #objectExists == 0 then
			self:__disconnectTagRemovedConnection()
		end
	end
	
	rawset(self, "__tagRemovedConnection", CollectionService:GetInstanceRemovedSignal(tomeTag):Connect(instanceRemoved))
end

--[[
	
	Tome:__disconnectTagRemovedConnection() : ()
	
	An internal method used to unbind/disconnect the "tag removed" connection. This method
	shouldn't be called outside this scope.
	
]]
function Tome:__disconnectTagRemovedConnection() : ()
	local tagRemovedConnection: RBXScriptConnection? = self:__getTagRemovedConnection()
	if tagRemovedConnection then
		tagRemovedConnection:Disconnect()
		
		rawset(self, "__tagRemovedConnection", nil)
	end
end

--[[
	
	Tome:__getTagRemovedConnection() : RBXScriptConnection?
	
	Returns the state of the "tag removed" connection. This method shouldn't be
	called outside this scope.
	
]]
function Tome:__getTagRemovedConnection() : RBXScriptConnection?
	-- explicitly annotate the connection so rawget doesn't complain
	return rawget(self, "__tagRemovedConnection") :: RBXScriptConnection?
end

--[[
	
	Tome:Rename(name: string) : Tome
	
	Renames the Tome. Throwns an error if the name argument isn't a string type, or nil.
	If the name argument provided is nil, it will erase the name property from the Tome.
	
	Typically this isn't useful and is really only used internally to manage Pages between
	other Tomes.
	
]]
function Tome:Rename(name: string?) : Types.Tome
	local nameType: string = type(name)
		assert(nameType == "string" or nameType == nil, "Tome:Rename name argument must be a string type, or nil.")
	
	self.__name = name
	
	return self
end

--[[
	
	Tome:AddPage(name: string?) -> Tome
	
	Constructs a Tome Page, also just referred to as a Page. A Page is similar to an
	extension method for any class; where the class constructs itself and mounts the
	newly constructed class to itself.
	
	Takes in a name argument which will force the Page to use a given name. This is
	useful in codebases that may need to acquire a Page by name. The name argument
	must be a string type, or nil. If the name argument is nil, a standard 128 guid
	will be used instead.
	
	Will throw an error if a Page under the parent Tome already has the provided name.
	
	If the Page has been constructed successfully, the Page will then be returned.
	If the Page wasn't referenced in the original scope, Tome:GetPage can be used
	to acquire the Page by name.
	
	Will throw an error if the Tome is in the middle of being destroyed.
	
	```lua
	local Tome = require(`Path`)
	local someTome = Tome.new()
	
	-- construct a new Page for the Tome
	local somePage = someTome:AddPage()
	
	-- add an apple to the Page
	somePage:Add(workspace.Apple)
	
	-- add a banana to the Tome
	someTome:Add(workspace.Banana)
	
	-- destroys both the apple, and banana as the Page also gets destroyed
	someTome:Destroy()
	```
	
	```lua
	local Tome = require(`Path`)
	local someTome = Tome.new()
	
	-- construct a new Page for the Tome with a provided name
	someTome:AddPage("SomeName")
	
	-- get the Page by name
	local somePage = someTome:GetPage("SomeName")
	```
	
]]
function Tome:AddPage(name: string?, metaprops: Types.Metaprops?) : Types.Tome
	assert(type(name) == "string" or name == nil, "Tome:AddPage name argument must be a string type, or nil.")
	
	if self:IsDestroying() then
		error(string.format(TOME_IS_DESTROYING_ERROR_MESSAGE, "add a Page to the Tome"))
	end
	
	if not name then
		name = HttpService:GenerateGUID(false)
	end
	
	local page: Types.Tome? = self.__pages[name]
	if page then
		ThrowError("Attempted to add a Page that already exists with the given name.")
	end
	
	local newMetaprops: Types.Metaprops? = nil
	if not metaprops and self.__useParentMetaprops then
		local fast: boolean = self.__fast
		local fastDestroy: boolean = self.__fastDestroy
		local warnings: boolean = self.__warnings
		local tagging: boolean = self.__tagging
		local useParentMetaprops: boolean = self.__useParentMetaprops
		
		newMetaprops = {
			Fast = fast,
			FastDestroy = fastDestroy,
			Warnings = warnings,
			Tagging = tagging,
			UseParentMetaprops = useParentMetaprops,
		}
	end
	
	local newPage: Types.Tome = Tome.new(newMetaprops)
	newPage:Rename(name)
	newPage.__parentTome = self
	
	self.__pages[name] = newPage
	
	return newPage
end

-- synonyms for the nesting more Tomes
-- primarily from older versions of the module
Tome.extend = Tome.AddPage
Tome.Extend = Tome.AddPage

--[[
	
	Tome:__findPage(pageToFind) : (Tome, Tome)?
	
	Attempts to find a particular Page with a deep search of all Pages and sub Pages.
	This is an internal method and shouldn't be used outside this scope. Use Tome:GetPage
	to acquire a Page instead.
	
]]
function Tome:__findPage(pageToFind: Types.Tome) : (Types.Tome?, Types.Tome?)
	local subPages: {any} = {}
	
	for _: string, page: Types.Tome in self.__pages do
		if page == pageToFind then
			return page, self
		end
		
		table.insert(subPages, page)
	end
	
	for _, page: Types.Tome in subPages do
		local pageFound: Types.Tome? = page:__findPage(pageToFind)
		if pageFound then
			return pageFound, page
		end
	end
	
	return
end

--[[
	
	Tome:GetParentTome() : Tome?
	
	Returns the parent Tome of the Tome.
	
	```lua
	local Tome = require(`Path`)
	local someTome = Tome.new()
	
	local somePage = someTome:AddPage()
	
	print(someTome:GetParentTome()) -> ()
	print(somePage:GetParentTome()) -> Tome (someTome)
	```
	
]]
function Tome:GetParentTome() : Types.Tome?
	return self.__parentTome
end

--[[
	
	Tome:__getLastParentTome() : Tome?
	
	Returns the true parent of the Tome.
	
	This is an internal method that shouldn't be used outside this scope.
	
]]
function Tome:__getLastParentTome() : Types.Tome?
	local parentTome: Types.Tome? = self:GetParentTome()
	if parentTome then
		local lastParent: Types.Tome? = nil
		
		while parentTome ~= nil do
			lastParent = parentTome
			parentTome = parentTome.__parentTome
		end
		
		return lastParent or parentTome
	end
	
	return
end

--[[
	
	Tome:RipPage(name: string | Tome) -> ()
	
	Destroys a Page within the Tome. The nameOrPage argument can take in a
	string or Tome type (a Page) If a Page is provided. The Tome will scan
	through itself and attempt to locate the provided Page through all sub
	Pages as well. Elsewise, if a string is provided, the Tome will search
	through only its children Pages, and no descendant Pages.
	
	Regardless of the way the Tome searches for the Pages, if no page is
	found, an error will be thrown.
	
	If a Page is found successfully, the Page will be destroyed, and erased
	from the Tome completely.
	
	Will throw an error if the Tome is in the middle of being destroyed.
	
	```lua
	local Tome = require(`Path`)
	local someTome = Tome.new()
	
	local somePage = someTome:AddPage("SomePage")
	
	print(someTome:GetPage("SomePage")) -> Page (somePage)
	
	someTome:RipPage(somePage)
	
	print(someTome:GetPage("SomePage")) -> ()
	```
	
]]
function Tome:RipPage(nameOrPage: string | Types.Tome) : ()
	local nameOrPageType: string = RealTypeOf(nameOrPage)
		assert(nameOrPageType == "string" or nameOrPageType == "Tome", "Tome:RipPage nameOrPage argument must be a string or Tome type.")
	
	if self:IsDestroying() then
		error(string.format(TOME_IS_DESTROYING_ERROR_MESSAGE, "rip Page from the Tome"))
	end
	
	if nameOrPageType == "Tome" then
		local page: Types.Tome?, parentPage: Types.Tome? = self:__findPage(nameOrPage)
		if not page or not parentPage then
			return ThrowError("Attempted to rip a Page that doesn't exist. Profiled using recursion")
		end
		
		page:Destroy()
		
		local pageName: string? = page.__name
		if pageName then
			parentPage.__pages[pageName] = nil
		end
		
		return
	end
	
	local page: Types.Tome? = self.__pages[nameOrPage]
	if not page then
		return ThrowError("Attempted to rip a Page that doesn't exist. Profiled using a string")
	end
	
	self.__pages[nameOrPage] = nil
	
	page:Destroy()
end

--[[
	
	Tome:RipPages() : ()
	
	Rips all the Pages contained within the Tome. Useful when needing
	to dispose of  Pages that don't need to occupy the Tome anymore.
	
]]
function Tome:RipPages() : ()
	self:DestroyAllPages()
	
	table.clear(self.__pages)
end

--[[
	
	Tome:GetPage(name: string) -> Tome?
	
	Attempts to return a Page from a given name. Typically useful when a Tome is shared
	among other scripts, and in some cases fetching a specific Page may be necessary.
	
	Will throw an error if the Tome is in the middle being destroyed.
	
]]
function Tome:GetPage(name: string) : Types.Tome?
	assert(type(name) == "string", "Attempted to acquire a Page, however the name argument provided wasn't a string type")
	
	if self:IsDestroying() then
		error(string.format(TOME_IS_DESTROYING_ERROR_MESSAGE, "get a Page"))
	end
	
	return self.__pages[name]
end

--[[
	
	Tome:Parent(newTome: Tome) : Tome
	
	Parents the current Tome to a new Tome. Takes in an argument, newTome, either
	a Tome type, or nil. If the newTome type is a Tome, then the current Tome will
	dissociate from its parent (provided it has one) and will reference itself
	within the new Tome. Elsewise, if nil is provided, it will dissociate itself
	from its parent (again, provided it has one) and it won't be referenced in
	any other Tome (unless by other means)
	
	Will throw an error if either Tome is in the middle of destroying.
	
]]
function Tome:Parent(newTome: Types.Tome?) : Types.Tome
	local isTome: boolean = RealTypeOf(newTome) == "Tome"
		assert(isTome or newTome == nil, "Tome:Parent newTome argument must be a Tome type, or nil.")
	
	if self:IsDestroying() then
		error(string.format(TOME_IS_DESTROYING_ERROR_MESSAGE, "parent a Tome"))
	end
	
	if newTome and newTome:IsDestroying() then
		ThrowError("Cannot add the current Tome to the newTome because the new Tome is in the middle of being destroyed.", "Ensure the new Tome is not destroying with Tome:IsDestroying.")
	end
	
	local parentTome: Types.Tome? = self.__parentTome
	if parentTome then
		self.__parentTome = nil
		
		parentTome.__pages[self.__name] = nil
	end
	
	if newTome then
		newTome.__pages[self.__name] = self
		
		self.__parentTome = newTome
	end
	
	return self
end

--[[
	
	Tome:GivePage(page: Tome, newTome: Tome) : Tome
	
	Very similar to Tome:Parent, with the only difference being that
	the Tome to parent is passed in as an argument (typically, a Page)
	This is useful when needing to parent the Page of a Tome.
	
]]
function Tome:GivePage(page: Types.Tome, newTome: Types.Tome) : Types.Tome
	local isPage: boolean = RealTypeOf(page) == "Tome"
		assert(isPage, "page argument must be a Tome type.")
	
	local isTome: boolean = RealTypeOf(newTome) == "Tome"
		assert(isTome, "newTome argument must be a Tome type.")
	
	return page:Parent(newTome)
end

--[[
	
	Tome:Move(object: Tome, otherTome: Tome) : object
	
	New: The type of the parsed object will remain, meaning type annotations
	will now be present even after internal addition
	
	Moves an object from the current Tome to another Tome and returns the
	object that was provided.
	
	Will throw an error if the Tome is in the middle of being destroyed.
	
	```lua
	local Tome = require(`Path`)
	local someTome = Tome.new()
	local someOtherTome = Tome.new()
	
	local apple = workspace.Apple
	someTome:Add(apple)
	
	print(someTome:Find(apple)) -- true
	
	-- Move the apple to the other Tome
	someTome:Move(apple, someOtherTome)
	
	print(someTome:Find(apple)) -- false
	print(someOtherTome:Find(apple)) -- true
	```
	
]]
function Tome:Move<object>(object: object, otherTome: Types.Tome) : object
	local parentIsTome: boolean = RealTypeOf(otherTome) == "Tome"
	if not parentIsTome then
		ThrowError("Tome:Move otherTome argument must be a Tome.", "Ensure the provided 'otherTome' argument is a Tome.")
	end
	
	if self:IsDestroying() then
		error(string.format(TOME_IS_DESTROYING_ERROR_MESSAGE, "move object to another Tome"))
	end
	
	self:Remove(object)
	otherTome:Add(object)
	
	return object
end

--[[
	
	Tome:Add(object: any, destroyMethod: Types.DestroyMethod?) : object
	
	New: The type of the parsed object will remain, meaning type annotations
	will now be present even after internal addition
	
	Adds an object to the Tome. Only the following classes can be added to
	the Tome: "Instance", "RBXScriptConnection", "Class", "Tween" and "function"
	Before an object is fully added to the Tome, the Tome will attempt to
	get the destroy method for the object. For example, if the object is an
	Instance, the "Destroy" method will be used on the Instance when it
	will be cleaned up. However, a custom destroy method can be passed in
	the second argument - This is useful for custom classes and objects.
	
	Behind the scenes, if the provided object is an Instance, it will be
	tagged with the tag of the Tome. This tag is used to erase the reference
	from the Tome if the object is destroyed externally, such as the void.
	
	If the object needs to be destroyed, but it also exists within the Tome
	ensure to remove it by calling Tome:Remove. This is important for custom
	classes and threads, as they aren't taggable.
	
	After everything has been completed, the object that was provided will
	be returned.
	
	Will throw an error if the Tome is in the middle of being destroyed.
	
	```lua
	local Tome = require(`Path`)
	local someTome = Tome.new()
	
	local cube = someTome:Add(workspace.Cube)
	
	-- will destroy the cube
	someTome:Destroy()
	```
	
	```lua
	local Tome = require(`Path`)
	local someTome = Tome.new()
	
	-- Giving in a custom destroy method, in this case "Destroy"
	-- which will be called on the cube as a function
	local cube = someTome:Add(workspace.Cube, "Destroy")
	
	-- will destroy the cube
	someTome:Destroy()
	```
	
	```lua
	local Tome = require(`Path`)
	local someTome = Tome.new()
	
	-- Giving in another custom method, in this case a function.
	-- This function will be called when the Tome is destroyed,
	-- giving in the object as the first argument. Typically the function
	-- will dipose of the object itself, this is useful for Promises which
	-- aren't currently supported.
	local cube = someTome:Add(workspace.Cube, function(cube: BasePart)
		cube:Destroy()
	end)
	
	-- will destroy the cube
	someTome:Destroy()
	```
	
]]
function Tome:Add<object>(object: object, destroyMethod: Types.DestroyMethod?) : object
	if self:IsDestroying() then
		error(string.format(TOME_IS_DESTROYING_ERROR_MESSAGE, "add an object"))
	end
	
	-- should be a significant write speed increase when using Fast
	-- still considering alternative faster options such as unsafe writing:
	if not self.__fast then
		local objectType: string = RealTypeOf(object)
		local objectIsTome: boolean = objectType == "Tome"
		if objectIsTome then
			if object == self then
				ThrowError("Attempted to add current Tome to the current Tome. Upon calling :Destroy, infinite recursion will occur", "Ensure that the Tome isn't added to itself.")
			end
			
			local lastParent: Types.Tome? = self:__getLastParentTome()
			if lastParent == object then
				ThrowError("[Recursive]: Attempted to add a Tome which is an ancestor Tome of the current Tome.", "Ensure no ancestor Tomes are added to the Tome.")
			end
		end
		
		-- not reusing 'objectType' for strict type compliancy
		if typeof(object) == "Instance" and not object:IsA("Tween") then
			if not object:IsDescendantOf(game) then
				ThrowError([[
					Attempted to add an already destroyed object to the Tome. If you are adding an Instance that hasn't been parented yet
					This error will persist. Consider turning off Tagging via Tome.new({ Tagging = false }) or setting it to false globally:
					Tome.luau -> Static.luau -> Tagging = false,
				]])
			end
			
			-- tomeTag will only have a string if tagging was enabled during instantiation
			-- if somewhere down the line metaprops can be updated after instantiation
			-- this code will need to be updated to comply
			local tomeTag: string? = self:GetTag()
			if tomeTag then
				object:AddTag(tomeTag)
			end
			
			self:__connectTagRemoved()
		end
	end
	
	self.__objects[object] = destroyMethod or GetDestroyMethodForObject(object)
	
	return object
end

--[[
	@partial-public method
	Tome:FastAdd<object>(object: object, destroyMethod: Types.DestroyMethod) : object
	
	Adds an object into the Tome while bypassing all sanity checks.
	This includes checking whether the Tome is being destroyed, and all meta props
	
	This method is now free to use in Prod-envs. There are a few caveats, but generally
	it's safe to use.
	
]]
function Tome:FastAdd<object>(object: object, destroyMethod: Types.DestroyMethod?) : object
	self.__objects[object] = destroyMethod or GetDestroyMethodForObject(object)
	
	return object
end

--[[
	
	Tome:AddTuple(...: any) : ...any
	
	New: The type of the parsed objects will remain, meaning type annotations
	will now be present even after internal addition
	
	Adds tuple objects to the Tome in the order they were given. After all the objects
	have been inserted, the objects will be returned in to the order they were given.
	
	Will throw an error if the Tome is in the middle of being destroyed.
	
	```lua
	local Tome = require(`Path`)
	local someTome = Tome.new()
	
	-- adds the apple, banana and pear to the Tome
	local apple, banana, pear = someTome:AddTuple(workspace.Apple, workspace.Banana, workspace.Pear)
	
	-- will destroy the apple, banana and pear
	someTome:Destroy()
	```
	
]]
function Tome:AddTuple<object...>(...) : object...
	if self:IsDestroying() then
		error(string.format(TOME_IS_DESTROYING_ERROR_MESSAGE, "add tuple objects to the Tome"))
	end
	
	for index: number, object: any in {...} do
		self:Add(object)
	end
	
	return ...
end

--[[
	
	Tome:AddFromArray(objectsArray: {[number]: any}) : objectsArray
	
	New:
		- The type of the parsed array will remain, meaning type annotations
		will now be present even after internal addition.
		
		- Uses generalized iteration over ipairs.
	
	Iterates over the provided objects and adds them to the Tome.
	
	Will throw an error if the Tome is in the middle of being destroyed.
	
	```lua
	local Tome = require(`Path`)
	local someTome = Tome.new()
	
	local objectsToAdd = {workspace.Apple, workspace.Banana, workspace.Pear}
	
	-- adds the apple, banana and pear to the Tome
	local returnedObjects = someTome:AddFromArray(fruits)
	
	-- will destroy the apple, banana and pear
	someTome:Destroy()
	```
	
]]
function Tome:AddFromArray<objectsArray>(objectsArray: objectsArray) : objectsArray
	assert(type(objectsArray) == "table", "Tome:AddFromArray objectsArray argument must be a table type (in array format).")
	
	if self:IsDestroying() then
		error(string.format(TOME_IS_DESTROYING_ERROR_MESSAGE, "add objects from array"))
	end
	
	-- unpacking the array into an actual array so the type solver doesn't complain
	-- bit of a waste of resources but hopefully this will be solved in the newer versions
	for index: number, object: any in {unpack(objectsArray)} do
		self:Add(object)
	end
	
	return objectsArray
end

--[[
	
	Tome:AddPromise(promise: any) : any
	
	Adds a standard Promise to the Tome.
	
	Will throw an error if the Promise has already finished executing.
	Will throw an error if the Tome is in the middle of being destroyed.
	
]]
function Tome:AddPromise(promise: Types.Promise) : any -- any should be considered a Promise, for better auto complete make sure to type cast (promise :: Promise)
	assert(promise
		and type(promise) == "table"
		and type(promise.getStatus) == "function"
		and type(promise.finally) == "function"
		and type(promise.cancel) == "function"
		,[[
			Tome:AddPromise promise argument must be a Promise.
		]]
	)
	
	if self:IsDestroying() then
		error(string.format(TOME_IS_DESTROYING_ERROR_MESSAGE, "add Promise"))
	end
	
	local castedPromise: Types.Promise = promise
	
	local status: string = string.lower(castedPromise:getStatus())
	if status == "started" then
		castedPromise:finally(function()
			self.__objects[castedPromise] = nil
		end)
		
		return self:Add(castedPromise, "cancel")
	end
	
	return ThrowError("The provided Promise has already finished executing.", "Ensure the provided Promise is still active.")
end

--[[
	
	Tome:Remove(object: any) : object
	
	New: The type of the parsed object will remain, meaning type annotations
	will now be present even after internal addition.
	
	Removes an object from the Tome. The provided object will be become unreferenced
	in the Tome and will be unable to be destroyed by the Tome. If the object is an
	Instance, the tag the Tome uses will be removed from the object.
	
	Will throw an error if the Tome is in the middle of being destroyed.
	
	```lua
	local Tome = require(`Path`)
	local someTome = Tome.new()
	
	local cube = someTome:Add(workspace.Cube)
	
	-- remove the cube from the Tome
	someTome:Remove(cube)
	
	-- will not destroy the cube as it was removed before the Tome was destroyed.
	someTome:Destroy()
	```
	
]]
function Tome:Remove<object>(object: object) : object
	if self:IsDestroying() then
		error(string.format(TOME_IS_DESTROYING_ERROR_MESSAGE, "remove an object"))
	end
	
	if typeof(object) == "Instance" then
		local tomeTag: string? = self:GetTag()
		if tomeTag then
			object:RemoveTag(tomeTag)
		end
	end
	
	self.__objects[object] = nil
	
	return object
end

--[[
	
	Tome:__remove(object: any) : ()
	
	Removes an object from the Tome. Bypassing any checks. Generally this is only
	used internally and shouldn't be used outside this scope.
	
]]
function Tome:__remove<object>(object: object) : object
	self.__objects[object] = nil
	
	return object
end

--[[
	
	Tome:RemoveTuple(...: any) : ...any
	
	New: The type of the parsed objects will remain, meaning type annotations
	will now be present even after internal addition.
	
	Removes tuple objects from the Tome. Functions exactly the same as Tome:Remove
	with the only difference being that tuple objects can be passed.
	
	Will throw an error if the Tome is in the middle of being destroyed.
	
	```lua
	local Tome = require(`Path`)
	local someTome = Tome.new()
	
	local apple, banana, pear = someTome:AddTuple(workspace.Apple, workspace.Banana, workspace.Pear)
	
	-- don't include the pear
	someTome:RemoveTuple(apple, banana)
	
	-- will only destroy the pear, as the apple and the banana were removed from the Tome
	someTome:Destroy()
	```
	
]]
function Tome:RemoveTuple<object...>(...) : object...
	if self:IsDestroying() then
		error(string.format(TOME_IS_DESTROYING_ERROR_MESSAGE, "remove tuple objects"))
	end
	
	for _: number, object: any in {...} do
		self:Remove(object)
	end
	
	return ...
end

--[[
	
	Tome:RemoveFromArray(objectsArray: {[number]: any}) : objectsArray
	
	New: The type of the parsed array will remain, meaning type annotations
	will now be present even after internal addition.
	
	Removes objects contained within a provided array from the Tome. The objectArray argument
	must be an array and must not contain any nils or incorrect index increments.
	
	Will throw an error if the Tome is in the middle of being destroyed.
	
	```lua
	local Tome = require(`Path`)
	local someTome = Tome.new()
	
	local objects = {workspace.Apple, workspace.Banana, workspace.Pear}
	
	-- adds the apple, banana and pear
	someTome:AddFromArray(objects)
	
	-- removes the apple, banana and pear
	someTome:RemoveFromArray(objects)
	
	-- destroys the Tome, and no objects get destroyed
	someTome:Destroy()
	```
	
]]
function Tome:RemoveFromArray<objectsArray>(objectsArray: objectsArray) : objectsArray
	assert(type(objectsArray) == "table", "Tome:RemoveFromArray objectArray argument must be a table type.")
	
	if self:IsDestroying() then
		error(string.format(TOME_IS_DESTROYING_ERROR_MESSAGE, "remove objects from array"))
	end
	
	for _: number, object: any in objectsArray do
		self:Remove(object)
	end
	
	return objectsArray
end

--[[
	
	Tome:RemoveObjectsWithTag(tag: string) : ()
	
	Removes objects from the Tome that contain a specified tag.
	
	Will throw an error if the Tome is in the middle of being destroyed.
	
	```lua
	local Tome = require(`Path`)
	local someTome = Tome.new()
	
	-- add a tag to the cube
	local cube = workspace.Cube
	cube:AddTag("SomeTag")
	
	-- add the cube to the Tome
	someTome:Add(cube)
	
	-- will remove the cube as it contains the "SomeTag" tag
	someTome:RemoveObjectsWithTag("SomeTag")
	```
	
]]
function Tome:RemoveObjectsWithTag(tag: string) : ()
	assert(type(tag) == "string", "Tome:RemoveObjectsWithTag tag argument must be a string type.")
	
	if self:IsDestroying() then
		error(string.format(TOME_IS_DESTROYING_ERROR_MESSAGE, "remove objects with tag"))
	end
	
	local objectsWithTag: {any} = self:GetObjectsWithTag(tag)
	
	self:RemoveFromArray(objectsWithTag)
end

--[[
	
	Tome:RemoveObjectsOfClass(className: string) : ()
	
	Removes objects from the Tome that have the specified class name.
	
	Will throw an error if the Tome is in the middle of being destroyed.
	
	```lua
	local Tome = require(`Path`)
	local someTome = Tome.new()
	
	local cube = workspace.Cube -- "Part"
	local someModel = workspace.SomeModel -- "Model"
	
	-- add the objects to the Tome
	someTome:AddTuple(cube, someModel)
	
	-- remove the objects that are a "Model"
	someTome:RemoveObjectsOfClass("Model")
	
	-- destroys only the cube as the "someModel" object was removed prior because it was a model
	someTome:Destroy()
	```
	
]]
function Tome:RemoveObjectsOfClass(className: string) : ()
	assert(type(className) == "string", "Tome:RemoveObjectsOfClass className argument must be a string type.")
	
	if self:IsDestroying() then
		error(string.format(TOME_IS_DESTROYING_ERROR_MESSAGE, "remove objects of class"))
	end
	
	local objectsOfClass: {any} = self:GetObjectsOfClass(className)
	
	self:RemoveFromArray(objectsOfClass)
end

--[[
	
	Tome:Connect(signal: RBXScriptSignal, listener: () -> ()) : RBXScriptConnection
	
	Connects a listener function to a RBXScriptSignal or custom Signal.
	
	Will thrown an error if the Tome is in the middle of being destroyed.
	
	```lua
	local Tome = require(`Path`)
	local someTome = Tome.new()
	
	local Players = game:GetService("Players")
	
	local function playerAdded(player: Player)
		print(string.format("Welcome! %s", player.DisplayName))
	end
	
	-- connects the playerAdded function to the Players.PlayerAdded signal
	someTome:Connect(Players.PlayerAdded, playerAdded)
	
	task.wait(5)
	
	-- and then destroy the Tome which removes the connection
	-- which doesn't welcome any more players :(
	someTome:Destroy()
	```
	
]]
function Tome:Connect(signal: any, listener: (...any) -> (...any)) : any
	if self:IsDestroying() then
		ThrowError(string.format(TOME_IS_DESTROYING_ERROR_MESSAGE, "connect to a signal"))
	end
	
	-- Added 24/12/2024 to fix regular Signals being attached
	local realType: string = typeof(signal)
	if realType == "RBXScriptSignal" then
		return self:Add(signal:Connect(listener))
	end
	
	--[[local connectFunction = signal.Connect or signal.connect
	if not connectFunction then
		ThrowError("Tome:Connect signal argument must be a RBXScriptSignal or custom Signal.")
	end]]
	
	-- Added 22/12/2024 to fix external Signals not being connectable
	return self:Add(signal:Connect(listener))
end

--[[
	
	Tome:Once(signal: RBXScriptSignal, listener: () -> ()) : RBXScriptConnection
	
	Connects a listener function once to a RBXScriptSignal or custom Signal.
	Once invoked, the connection will be automatically disconnected, but will
	remaing within the Tome until Tome:Destroy is called.
	
	Will thrown an error if the Tome is in the middle of being destroyed.
	
	```lua
	local Tome = require(`Path`)
	local newTome = Tome.new()
	
	local Players = game:GetService("Players")
	
	local function playerAdded(player: Player)
		print(string.format("The first player to join was: %*", player))
	end
	
	-- connects the playerAdded function to the Players.PlayerAdded signal
	-- once a player joins, the connection will disconnect
	newTome:Once(Players.PlayerAdded, playerAdded)
	```
	
]]
function Tome:Once(signal: RBXScriptSignal, listener: (...any) -> (...any)) : any
	if self:IsDestroying() then
		ThrowError(string.format(TOME_IS_DESTROYING_ERROR_MESSAGE, "connect once to a signal"))
	end
	
	--[[if not signal.Once then
		ThrowError("Tome:Once signal argument must be a RBXScriptSignal or custom Signal.")
	end]]
	
	return self:Add(signal:Once(listener))
end

--[[
	
	Tome:Construct(class: {new: () -> ()} | () -> ()) : any
	
	Constructs the provided class as if calling Class.new. Accepts both the class and
	class function. After the class argument, tuple arguments can be provided which
	will be passed into the constructed class. If neither a constructor function or
	class is provided, an error will be thrown. If the construction of the class is a
	success, the constructed class will be returned.
	
	Will throw an error if the Tome is in the middle of being destroyed.
	
	```lua
	local Tome = require(`Path`)
	local SomeClass = require(`Path`)
	
	local someTome = Tome.new()
	
	local class = someTome:Construct(SomeClass, "Apple", "Banana", "Pear")
	
	-- will destroy the class object
	someTome:Destroy()
	```
	
	```lua
	local Tome = require(`Path`)
	local SomeClass = require(`Path`)
	
	local someTome = Tome.new()
	
	-- using the class constructor function as the first argument
	local class = someTome:Construct(SomeClass.new, "Apple", "Banana", "Pear")
	
	-- will destroy the class object
	someTome:Destroy()
	```
	
]]
function Tome:Construct(class: any, ...: any) : any
	if self:IsDestroying() then
		error(string.format(TOME_IS_DESTROYING_ERROR_MESSAGE, "construct a class"))
	end
	
	local classType: string = type(class)
	if classType == "table" then
		local constructFunction: (() -> ())? = class.new
		local functionType: string = type(constructFunction)
		
		if functionType == "function" and constructFunction then
			return self:Add(constructFunction(...))
		end
	end
	
	if classType == "function" then
		return self:Add(class(...))
	end
	
	ThrowError([[Attempted to construct a new class with Tome:Construct,
		however the class provided was not a class containing a .new function.
		Only a function or a table containing a .new function is allowed in Tome:Construct.]])
	
	return
end

--[[
	
	Tome:Duplicate() : Tome
	
	Duplicated the current Tome. The duplicate will include the same metadata and objects. To avoid
	copying over the metadata and objects, Tome:Clone is a better alternative.
	
	```lua
	local Tome = require(`Path`)
	local SomeClass = require(`Path`)
	
	local someTome = Tome.new()
	
	-- add the apple to the Tome
	someTome:Add(workspace.Apple)
	print(someTome:Has(workspace.Apple)) -> true
	
	-- duplicate the Tome
	local duplicateTome = someTome:Duplicate()
	print(duplicateTome:Has(workspace.Apple)) -> true
	
	-- destroys the apple as it existed within the duplicate Tome
	duplicateTome:Destroy()
	
	-- prints false because the apple was destroyed by the duplicate Tome
	print(someTome:Has(workspace.Apple)) -> false
	```
	
]]
function Tome:Duplicate() : Types.Tome
	if self:IsDestroying() then
		error(string.format(TOME_IS_DESTROYING_ERROR_MESSAGE, "duplicate the Tome"))
	end
	
	local duplicateTome: Types.Tome = Tome.new({
		Fast = self.__fast,
		FastDestroy = self.__fastDestroy,
		Warnings = self.__warnings,
		Tagging = self.__tagging,
		UseParentMetaprops = self.__useParentMetaprops,
	})
	
	for object: any, destroyMethod: any in self.__objects do
		duplicateTome:Add(object, destroyMethod)
	end
	
	return duplicateTome
end

--[[
	
	Tome:Clone(object: any, extendFunctionName: string?) : any
	
	Clones the provided object and adds it to the Tome. The provided object must be
	and Instance or class containing a function with the name of one of the extension
	method names. If a class is provided and an extension function isn't found, an
	error will be thrown. If an Instance is provided, the :Clone method will be used
	on it and the clone will be added to the Tome. If neither is provided, an error
	will be thrown.
	
	Will throw an error if the Tome is in the middle of being destroyed.
	
	```lua
	local Tome = require(`Path`)
	local someTome = Tome.new()
	
	local duplicateCube = someTome:Clone(workspace.Cube)
	
	-- will destroy the duplicate cube
	someTome:Destroy()
	```
	
	```lua
	local Tome = require(`Path`)
	local SomeClass = require(`Path`)
	
	local someTome = Tome.new()
	
	local class = someTome:Construct(SomeClass.new)
	local duplicateClass = someTome:Clone(class)
	
	-- both the class and duplicate class will be destroyed
	someTome:Destroy()
	```
	
]]
function Tome:Clone(object: any, extendFunctionName: string?) : any
	if self:IsDestroying() then
		error(string.format(TOME_IS_DESTROYING_ERROR_MESSAGE, "clone an object"))
	end

	local objectType: string = typeof(object)
	if objectType == "table" then
		local extensionFunction: ((object: any) -> ())? = extendFunctionName and object[extendFunctionName]
		if extensionFunction then
			return self:Add(extensionFunction(object))
		end
		
		for _: number, extensionName: string in EXTENSION_METHOD_NAMES do
			local extension: ((object: any) -> ())? = object[extensionName]
			if extension then
				return self:Add(extension(object))
			end
		end
		
		return ThrowError("Attempted to clone a table (most likely a class) however the table doesn't contain an extension/clone method.", "Ensure the provided class has en extension method. If it does, add it to the extension list at the top of the module.")
	elseif objectType == "Instance" then
		return self:Add(object:Clone())
	end

	error(string.format("Failed to clone object: %s", tostring(object)))
end

--[[
	
	Tome:Instance(instanceName: string, properties: {[string]: any}?) : Instance
	
	Attempts to create an Instance from a provided class name. Behind the scenes Instance.new
	is called within a pcall to safely evaluate the result. If an Instance was created successfully
	the newly created Instance will be added to the Tome. Elesewise an error will be thrown.
	
	An optional properties table can be provided which will set the properties of the Instance.
	If one of the properties fail to be applied to the Instance, a warning will be thrown. It should
	be ensured that the properties table that's provided doesn't contain any properties that don't
	exist within the Instance.
	
	Will throw an error if the Tome is in the middle of being destroyed.
	
	```lua
	local Tome = require(`Path`)
	local someTome = Tome.new()
	
	local part = someTome:Instance("Part")
	part.Parent = workspace
	
	task.wait(2)
	
	someTome:Destroy() -- Destroys the part
	```
	
	```lua
	local Tome = require(`Path`)
	local someTome = Tome.new()
	
	local part = someTome:Instance("Part", {
		Color = Color3.new(1, 1, 1),
		Size = Vector3.one,
		Parent = workspace,
	})
	
	task.wait(2)
	
	-- destroys the part
	someTome:Destroy()
	```
	
	```lua
	local Tome = require(`Path`)
	local someTome = Tome.new()
	
	-- will throw an error as "Apple" isn't an actual instance
	someTome:Instance("Apple")
	```
	
]]
function Tome:Instance(instanceName: string, properties: {[string]: any}?) : Instance?
	assert(type(instanceName) == "string", "The instanceName argument must be a string type.")
	assert(type(properties) == "table" or properties == nil, "The properties argument must be a table type or nil.")
	
	if self:IsDestroying() then
		error(string.format(TOME_IS_DESTROYING_ERROR_MESSAGE, "create an Instance"))
	end
	
	local success: boolean, result: Instance = pcall(Instance.new, instanceName)
	
	assert(success, string.format([[
		Attempted to construct a new Instance with the name %s, however that Instance class doesn't exist.
		Additional error message: %s
	]], tostring(instanceName), tostring(result)))
	
	if properties then
		local warnings: boolean = self.__warnings
		
		for property: string, value: any in properties do
			xpcall(function()
				(result :: any)[property] = value
			end, function(...)
				if not success and warnings then
					warn(string.format([[
						Attempted to apply property: %s to the created Instance.
					]], tostring(property)))
					warn("Extra details: ", ...)
				end
			end)
		end
	end
	
	return self:Add(result)
end

--[[
	
	Tome:FromExisting(instance: Instance) : Instance
	
	Creates an Instance with Instance.fromExisting given an Instance.
	
	Will throw an error if the Tome is in the middle of being destroyed.
	
]]
function Tome:FromExisting(instance: Instance) : Instance
	assert(typeof(instance) == "Instance", "Tome:FromExisting the instance argument must be an Instance type.")
	
	if self:IsDestroying() then
		error(string.format(TOME_IS_DESTROYING_ERROR_MESSAGE, "create an Instance from existing"))
	end
	
	return self:Add(Instance.fromExisting(instance))
end

--[[
	
	Tome:Attach(object: any) : RBXScriptSignal?
	
	Attaches an object to the Tome. If the object is an Instance, the Destroying Signal of
	the Instance will be listened for, and once it's fired, the Tome will destroy itself.
	If the object is a Tome, then a function will be added to that Tome. Once that Tome is
	destroyed, the function will fire, destroying the current Tome. If the object is a
	table that contains a :Connect method, then a listener function will connect to it and
	upon the listener being fired, the Tome will destroy itself.
	
	Will throw an error if the object provided could not be attached to the Tome.
	
	```lua
	local Tome = require(`Path`)
	local someTome = Tome.new()
	
	local cube = workspace.Cube
	
	-- attach the Tome to the cube
	someTome:Attach(cube)
	
	-- will also destroy the Tome, as the Tome attached to the cube
	cube:Destroy()
	```
	
]]
function Tome:Attach(object: any) : (RBXScriptConnection | () -> ())?
	local objectType: string = RealTypeOf(object)
	
	if objectType == "Tome" then
		return object:Add(function()
			self:Destroy()
		end)
	elseif objectType == "Instance" then
		if not object:IsA("Tween") and not object:IsDescendantOf(game) then
			ThrowError("Attempted to attach Tome to an Instance that doesn't exist.")
		end
		
		local wasDestroyed: boolean = false
		local wasNulled: boolean = false
		
		local destroyingConnection: RBXScriptConnection = self:Connect(object.Destroying, function()
			if wasDestroyed or wasNulled then
				return
			end
			
			wasDestroyed = true
			
			self:Destroy()
		end)
		
		local function ancestryChanged()
			local descendantOfGame: boolean = object:IsDescendantOf(game)
			
			if not descendantOfGame then
				if wasDestroyed or wasNulled then
					return
				end
				
				wasNulled = true
				
				self:Destroy()
			end
		end
		
		object.AncestryChanged:Connect(ancestryChanged)
		
		return destroyingConnection
	elseif objectType == "Signal" or (objectType == "table" and type(object.Connect) == "function") or objectType == "RBXScriptSignal" then
		return object:Connect(function()
			self:Destroy()
		end)
	end
	
	ThrowError(string.format("Could not attach object: %* to Tome.", object), "Ensure the provided object is either a Tome, Signal, Instance or class with a :Connect method.")
	
	return
end

--[[
	
	Tome:DestroyObjectsWithTag(tag: string) : ()
	
	Destroys all the objects contained within the Tome that have the specified tag.
	
	Will throw an error if the Tome is in the middle of being destroyed.
	
	```lua
	local Tome = require(`Path`)
	local someTome = Tome.new()
	
	local apple, banana, pear = workspace.Apple, workspace.Banana, workspace.Pear
	
	-- add all the fruits
	someTome:AddTuple(apple, banana, pear)
	
	-- tag only the apple and banana
	apple:AddTag("SomeTag")
	banana:AddTag("SomeTag")
	
	-- destroys only the apple and banana. The pear remains as it wasn't tagged
	someTome:DestroyObjectsWithTag("SomeTag")
	```
	
]]
function Tome:DestroyObjectsWithTag(tag: string) : ()
	assert(type(tag) == "string", "Tome:DestroyObjectsWithTag tag argument must be a string type.")
	
	if self:IsDestroying() then
		error(string.format(TOME_IS_DESTROYING_ERROR_MESSAGE, string.format("destroy objects with tag: %s", tag)))
	end
	
	local collectedObjects: {Instance} = self:GetObjectsWithTag(tag)
	local objectExists: boolean = TableUtility.isEmpty(collectedObjects)
	if objectExists then
		for _: number, object: Instance in collectedObjects do
			self:DestroyObject(object)
		end
	end
end

--[[
	
	Tome:DestroyObjectsOfClass(className: string) : ()
	
	Destroys all the objects contained within the Tome that are of a specified class.
	
	Will throw an error if the Tome is in the middle of being destroyed.
	
	```lua
	local Tome = require(`Path`)
	local someTome = Tome.new()
	
	-- the apple is a model
	someTome:Add(workspace.Apple)
	
	-- the cube is a part
	someTome:Add(workspace.Cube)
	
	-- will object destroy the cube
	someTome:DestroyObjectsOfClass("BasePart")
	```
	
]]
function Tome:DestroyObjectsOfClass(className: string) : ()
	assert(type(className) == "string", "Tome:DestroyObjectsOfClass className argument must be a string type.")
	
	if self:IsDestroying() then
		error(string.format(TOME_IS_DESTROYING_ERROR_MESSAGE, string.format("destroy objects of class: %s", className)))
	end
	
	local collectedObjects: {Instance} = self:GetObjectsOfClass(className)
	local objectExists: boolean = TableUtility.isEmpty(collectedObjects)
	if objectExists then
		for _: number, object: Instance in collectedObjects do
			self:DestroyObject(object)
		end
	end
end

--[[
	
	Tome:RenderStepped(listener: (deltaTime: number) -> ()) : RBXScriptConnection
	
	Connects the RunService.RenderStepped Signal to a listener function and adds the connection
	to the Tome.
	
	Will throw an error if the method is not called from the client.
	Will throw an error if the Tome is in the middle of being destroyed.
	
	```lua
	local Tome = require(`Path`)
	local someTome = Tome.new()
	
	local connection = someTome:RenderStepped(function(deltaTime: number)
		print(deltaTime)
	end)
	
	task.wait(2)
	
	-- will disconnect the connection
	someTome:Destroy()
	```
	
]]
function Tome:RenderStepped(listener: (deltaTime: number) -> ()) : RBXScriptConnection
	assert(type(listener) == "function", "Tome:RenderStepped listener argument must be a function type.")
	
	if self:IsDestroying() then
		ThrowError(string.format(TOME_IS_DESTROYING_ERROR_MESSAGE, "connect to RunService.RenderStepped"))
	end
	
	local isClient: boolean = RunService:IsClient()
	if not isClient then
		ThrowError([[
			Tome:RenderStepped can only be called on the client.
			Tome:Heartbeat is a good alternative that works for both the client, and server.
		]])
	end

	return self:Connect(RunService.RenderStepped, listener)
end

--[[
	
	Tome:Heartbeat(listener: (deltaTime: number) -> ()) : RBXScriptConnection
	
	Connects the RunService.Heartbeat Signal to a listener function and adds the connection
	to the Tome.
	
	Will throw an error if the Tome is in the middle of being destroyed.
	
	```lua
	local Tome = require(`Path`)
	local someTome = Tome.new()
	
	local connection = someTome:Heartbeat(function(deltaTime: number)
		print(deltaTime)
	end)
	
	task.wait(2)
	
	-- will disconnect the connection
	someTome:Destroy()
	```
	
]]
function Tome:Heartbeat(listener: (deltaTime: number) -> ()) : RBXScriptConnection
	assert(type(listener) == "function", "Tome:Heartbeat listener argument must be a function type.")

	if self:IsDestroying() then
		error(string.format(TOME_IS_DESTROYING_ERROR_MESSAGE, "connect to RunService.Heartbeat"))
	end

	return self:Connect(RunService.Heartbeat, listener)
end

--[[
	
	Tome:BindRenderStepped(name: string, listener: (deltaTime: number) -> (), renderPriority: number?) : () -> ()
	
	Calls the RunService:BindToRenderStep method and returns a function that when called, unbinds the
	binding to that render step. The argument order is the same, name, render priority and the listener.
	The render priority must be an integer, or nil. If the render priority is nil, 1 will be used as
	the fallback value.
	
	Will throw an error if the method is not called from the client.
	Will throw an error if the Tome is in the middle of being destroyed.
	
	```lua
	local Tome = require(`Path`)
	local someTome = Tome.new()
	
	local unbind = someTome:BindRenderStepped("Test", 1, function()
		print("hello!")
	end)
	
	-- Unbinds the render stepped binding
	task.delay(2, unbind)
	```
	
]]
function Tome:BindRenderStepped(name: string, renderPriority: number?, listener: (deltaTime: number) -> ()) : () -> ()
	assert(type(name) == "string", "Tome:BindRenderStepped name argument must be a string type.")
	assert(type(renderPriority) == "number" or renderPriority == nil, "Tome:BindRenderStepped renderPriority argument must be a number type, or nil.")
	assert(type(listener) == "function", "Tome:BindRenderStepped listener argument must be a function type.")
	
	if self:IsDestroying() then
		ThrowError(string.format(TOME_IS_DESTROYING_ERROR_MESSAGE, "bind to render step"))
	end
	
	local isClient: boolean = RunService:IsClient()
	if not isClient then
		ThrowError([[
			Tome:BindRenderStepped can only be called on the client.
			Tome:Heartbeat is a good alternative that works for both the client, and server.
		]])
	end
	
	if renderPriority then
		renderPriority = renderPriority and math.max(math.floor(renderPriority), 1) or 1
		
		RunService:BindToRenderStep(name, renderPriority, listener)
	end
	
	local function unbindRenderStepFunction() : ()
		self.__objects[unbindRenderStepFunction] = nil
		
		RunService:UnbindFromRenderStep(name)
	end
	
	return self:Add(unbindRenderStepFunction)
end

--[[
	
	Tome:UnbindRenderStepped(name: string) : ()
	
	Calls the RunService:UnbindFromRenderStep method provided a name.
	
	Will throw an error if the method is not called from the client.
	Will throw an error if the Tome is in the middle of being destroyed.
	
	```lua
	local Tome = require(`Path`)
	local someTome = Tome.new()
	
	someTome:BindRenderStepped("Test", 1, function(deltaTime: number)
		print(deltaTime)
	end)
	
	task.wait(2)
	
	someTome:UnbindRenderStepped("Test")
	```
	
]]
function Tome:UnbindRenderStepped(name: string) : ()
	assert(type(name) == "string", "Tome:UnbindRenderStepped name argument must be a string type.")
	
	local isClient: boolean = RunService:IsClient()
	if not isClient then
		ThrowError("Tome:UnbindRenderStepped can only be called on the client.")
	end
	
	RunService:UnbindFromRenderStep(name)
end

--[[
	
	Tome:Delay(duration: number, listener: (...any) -> (...any), ...: any) : thread
	
	Functions the exact same as task.delay, with the added benefit of adding the thread to
	the Tome immediately after it has been created. Tuple arguments can be passed after the
	listener function - the arguments will be passed into the task.delay function.
	
	Will throw an error if the Tome is in the middle of being destroyed.
	
	```lua
	local Tome = require(`Path`)
	local someTome = Tome.new()
	
	someTime:Delay(3, function()
		print("Pineapple!!!")
	end)
	
	someTome:Destroy()
	```
	
]]
function Tome:Delay(duration: number, listener: (...any) -> (...any), ...: any) : thread
	assert(type(duration) == "number", "Tome:Delay duration argument must be a number type,")
	assert(type(listener) == "function", "Tome:Delay listener argument must be a function type.")

	if self:IsDestroying() then
		error(string.format(TOME_IS_DESTROYING_ERROR_MESSAGE, "delay a thread"))
	end

	return self:Add(task.delay(duration, listener))
end

--[[
	
	Tome:Spawn(listener: (...any) -> (...any), ...: any) : thread
	
	Functions the exact same as task.spawn, with the added benefit of adding the thread to
	the Tome immediately after it has been created. Tuple arguments can be passed after the
	listener function - the arguments will be passed into the task.spawn function.
	
	Will throw an error if the Tome is in the middle of being destroyed.
	
	```lua
	local Tome = require(`Path`)
	local someTome = Tome.new()
	
	someTime:Spawn(function()
		while true do
			print("This thread is still running!")
			
			task.wait(1)
		end
	end)
	
	task.wait(5)
	
	-- cancels the thread preventing the loop from continuing
	someTome:Destroy()
	```
	
]]
function Tome:Spawn(listener: (...any) -> (...any), ...: any) : thread
	assert(type(listener) == "function", "Tome:Spawn listener argument must be a function type.")
	
	if self:IsDestroying() then
		error(string.format(TOME_IS_DESTROYING_ERROR_MESSAGE, "spawn a thread"))
	end
	
	return self:Add(task.spawn(listener, ...))
end

--[[
	
	Tome:Defer(listener: (...any) -> (...any), ...: any) : thread
	
	Functions the exact same as task.defer, with the added benefit of adding the thread to
	the Tome immediately after it has been created. Tuple arguments can be passed after the
	listener function - the arguments will be passed into the task.defer function.
	
	Will throw an error if the Tome is in the middle of being destroyed.
	
]]
function Tome:Defer(listener: (...any) -> (...any), ...: any) : thread
	assert(type(listener) == "function", "Tome:Defer listener argument must be a function type.")

	if self:IsDestroying() then
		error(string.format(TOME_IS_DESTROYING_ERROR_MESSAGE, "defer a thread"))
	end

	return self:Add(task.defer(listener, ...))
end

--[[
	
	Tome:Find(object: any) : boolean
	
	Checks if an object exists within the Tome.
	
	```lua
	local Tome = require(`Path`)
	local someTome = Tome.new()
	
	-- check if the cube exists initially, which of course, it doesn't
	local exists = someTome:Find(workspace.Cube)
	print(exists) -- False
	
	-- add the cube to the Tome
	someTome:Add(workspace.Cube)
	
	-- now that the cube has been added, it returns true
	local exists = someTome:Find(workspace.Cube)
	print(exists) -- True
	```
	
]]
function Tome:Find(object: any) : boolean
	return self.__objects[object] and true or false
end

-- An alias for Tome:Find as the word find may be obscure in some contexts
Tome.Has = Tome.Find

--[[
	TODO: Instate some kind of type inference for the Signal dependency.
	
	Type inference won't work here because Signal may not exist
	Current solution:
		Set the return type to 'any' to silence the issue
]]
--[[
	
	Tome:Signal() : Signal
	
	Constructs a standard Signal and returns it.
	
	Will throw an error if the Tome is in the middle of being destroyed.
	
	```lua
	local Tome = require(`Path`)
	local someTome = Tome.new()
	
	local signal = someTome:Signal()
	
	signal:Connect(function(something)
		print(something)
	end)
	
	-- acts like a normal Signal
	signal:Fire("Hello, world!")
	
	-- destroys the Signal
	someTome:Destroy()
	```
	
]]
function Tome:Signal() : any
	if self:IsDestroying() then
		error(string.format(TOME_IS_DESTROYING_ERROR_MESSAGE, "construct a Signal"))
	end
	
	return self:Construct(Signal)
end

--[[

	Tome:Table(existing: {}?) : {}
	
	Adds the given table to the Tome while using "table.clear" as the destroy method
	This is useful for when you want to clear a table after the Tome is destroyed
	
	Will throw an error if the Tome is in the middle of being destroyed.
	
	Bad practice:
		```lua
		local Tome = require(`Path`)
		local someTome = Tome.new()
		
		local myTable = someTome:Add({}, Tome.ClearTable)
		
		print(myTable)
		```
	
	Good practice:
		```lua
		local Tome = require(`Path`)
		local someTome = Tome.new()
		
		local myTable = someTome:Table({})
		
		print(myTable)
		```
	
]]
function Tome:Table(existing: {}?) : {}
	if self:IsDestroying() then
		error(string.format(TOME_IS_DESTROYING_ERROR_MESSAGE, "add a table"))
	end
	
	return self:Add(existing or {}, table.clear)
end

--[[
	
	Tome:Tween(instance: Instance, tweenInfo: TweenInfo, propertyTable: {[string]: any}, metadata: {}?) : Tween
	
	Creates a Tween object with the provided arguments. Very similar to TweenService:Create, where the
	first argument is the object to tween. The second argument is the tween info. And the third argument
	is the property table.
	
	However Tweens can be complex at times, and disposing of them requires slightly more effort. This is
	where metadata comes in. Metadata comes in table form and can contain three properties, "Play",
	"RemoveOnComplete" and "RemoveOnDestroy".
	
	The property Play is a boolean that determines whether the Tween should immediately play after being
	created.
	
	The property RemoveOnComplete is a boolean that determines whether the Tween should be removed from
	the Tome after it has been completed once. In cases where the same Tween plays multiple times, this
	property may be set to false to ensure proper clean up.
	
	The property RemoveOnDestroy is a boolean that determines whether the Tween should be removed after
	the Tween has been destroyed.
	
	Will throw an error if the Tome is in the middle of being destroyed.
	
]]
function Tome:Tween(
	instance: Instance,
	tweenInfo: TweenInfo,
	propertyTable: {[string]: any},
	metadata: {
		Play: boolean?,
		RemoveOnComplete: boolean?,
		RemoveOnDestroy: boolean?,
	}?
) : Tween
	assert(typeof(instance) == "Instance", "Tome:Tween instance argument must be an Instance type.")
	assert(typeof(tweenInfo) == "TweenInfo", "Tome:Tween tweenInfo argument must be a TweenInfo type.")
	assert(typeof(propertyTable) == "table", "Tome:Tween propertyTable argument must be a table type.")
	
	local metadataType: string = type(metadata)
		assert(metadataType == "table" or metadata == nil, "Tome:Tween metadata argument must be a table type, or nil.")
	
	if self:IsDestroying() then
		error(string.format(TOME_IS_DESTROYING_ERROR_MESSAGE, "create a Tween"))
	end
	
	if metadata then
		metadata.Play = if type(metadata.Play) == "boolean" then metadata.Play else true
		metadata.RemoveOnComplete = if type(metadata.RemoveOnComplete) == "boolean" then metadata.RemoveOnComplete else true
		metadata.RemoveOnDestroy = if type(metadata.RemoveOnDestroy) == "boolean" then metadata.RemoveOnDestroy else true
	end
	
	local realMetadata: Types.TweenMetadata = metadata or {
		Play = true,
		RemoveOnComplete = true,
		RemoveOnDestroy = true,
	}
	
	local tween: Tween = self:Add(TweenService:Create(instance, tweenInfo, propertyTable))
	
	if realMetadata.RemoveOnComplete then
		local function tweenCompleted(playbackState: Enum.PlaybackState) : ()
			local tweenEnded: boolean = playbackState == Enum.PlaybackState.Completed
				or playbackState == Enum.PlaybackState.Cancelled
			
			-- once the tween has reached either completed states
			-- it should be disposed from the Tome
			if tweenEnded then
				self.__objects[tween] = nil
			end
		end
		
		tween.Completed:Once(tweenCompleted)
	end
	
	if realMetadata.RemoveOnDestroy then
		-- for one reason or another, the tween mightve been destroyed
		-- to ensure the tween doesnt stay in memory its best to listen for when its destroyed, and properly dispose of it
		local function tweenDestroying() : ()
			self.__objects[tween] = nil
		end
		
		tween.Destroying:Once(tweenDestroying)
	end
	
	if realMetadata.Play then
		tween:Play()
	end
	
	return tween
end

--[[
	
	Tome:DestroyObject(object: any) : ()
	
	Destroys the provided object. The object must be within the Tome to be destroyed. Elsewise
	nothing will happen.
	
	Will throw an error if the Tome is in the middle of being destroyed.
	
	```lua
	local Tome = require(`Path`)
	local someTome = Tome.new()
	
	local apple, banana = someTome:AddTuple(workspace.Apple, workspace.Banana)
	
	-- the apple will be destroyed
	someTome:DestroyObject(apple)
	```
	
	```lua
	local Tome = require(`Path`)
	local someTome = Tome.new()
	
	local banana = workspace.Banana
	
	-- nothing will happen as the banana was never added to the Tome
	someTome:DestroyObject(banana)
	```
	
]]
function Tome:DestroyObject(object: any) : ()
	if self:IsDestroying() then
		error(string.format(TOME_IS_DESTROYING_ERROR_MESSAGE, "destroy object"))
	end

	local objects: {[any]: any} = self.__objects
	local destroyMethod: any = objects[object]
	if destroyMethod then
		local objectIsTome: boolean = RealTypeOf(object) == "Tome"
		if objectIsTome then
			return object:Destroy()
		end
		
		objects[object] = nil
		
		if self.__fastDestroy then
			pcall(task.spawn, DestroyObject, object, destroyMethod)
		else
			pcall(DestroyObject, object, destroyMethod)
		end
	end
end

--[[
	
	Tome:DestroyObjects(...: any) : ()
	
	Functions exactly the same as Tome:DestroyObjects, with the only difference being that
	tuple objects can be provided.
	
	Will throw an error if the Tome is in the middle of being destroyed.
	
	```lua
	local Tome = require(`Path`)
	local someTome = Tome.new()
	
	local apple, banana, pear = someTome:AddTuple(workspace.Apple, workspace.Banana, workspace.Pear)
	
	-- will only destroy the apple and banana
	someTome:DestroyObjects(apple, banana)
	```
	
]]
function Tome:DestroyObjects(...: any) : ()
	if self:IsDestroying() then
		error(string.format(TOME_IS_DESTROYING_ERROR_MESSAGE, "destroy objects"))
	end
	
	for _: number, object: any in {...} do
		self:DestroyObject(object)
	end
end

--[[
	
	Tome:CanDestroy() : boolean
	
	Returns a boolean which determines whether the Tome can be destroyed. Generally, this method
	doesn't need to be called before destroying the Tome, unless there's a deeper reason to do
	so.
	
	```lua
	local Tome = require(`Path`)
	local someTome = Tome.new()
	
	print(someTome:CanDestroy()) -- true
	
	-- this function contains a yield that will pause the Tome for 2 seconds
	someTome:Add(function()
		task.wait(2)
	end)
	
	-- delay the code below by 0.5 seconds to let the Tome begin a destroy sequence
	task.delay(0.5, function()
		print(someTome:CanDestroy()) -- false, as the Tome is currently in the middle of being destroyed
	end)
	
	someTome:Destroy()
	```
	
]]
function Tome:CanDestroy() : boolean
	return not self.__destroying
end

--[[
	
	Tome:IsDestroying() : boolean
	
	Returns whether or not the Tome is currently destroying.
	
]]
function Tome:IsDestroying() : boolean
	return self.__destroying
end

--[[
	
	Tome:GetObjects() : {[any]: any}
	
	Returns all the objects contained within the Tome. This should only be used to modify
	the objects and not destroy them directly.
	
	```lua
	local Tome = require(`Path`)
	local someTome = Tome.new()
	
	someTome:AddTuple(workspace.Apple, workspace.Banana)
	
	print(someTome:GetObjects()) -> {[Instance(Apple,REF)] = "Destroy", [Instance(Banana,REF)] = "Destroy"}
	```
	
]]
function Tome:GetObjects() : {[any]: any}
	return self.__objects
end

--[[
	
	Tome:Count() : number
	
	Returns the total amount of objects currectly inside the Tome
	
	```lua
	local Tome = require(`Path`)
	local someTome = Tome.new()
	
	someTome:AddTuple(workspace.Apple, workspace.Banana, workspace.Pear)
	
	print(someTome:Count()) --> 3
	
	```
	
]]
function Tome:Count() : number
	local count: number = 0
	
	local objects: {[any]: string} = self.__objects
	for object: any in objects do
		count += 1
	end
	
	return count
end

--[[
	
	Tome:GetObjectsOfClass(className: string) : {[any]: any}
	
	Returns an array of objects contained within the Tome that are
	of a certain class name. The method will iterate over all the
	objects allocated to the Tome and see if the class name is a
	match.
	
	For every iteration, if an object is an Instance type and has
	the same ClassName property as the className argument, it will
	be added to the list of objects to return.
	
	If an object is a Tome or Signal, it will check if the className
	is directly equal to the __type property of the Tome/Signal.
	
	```lua
	local Tome = require(`Path`)
	local someTome = Tome.new()
	
	someTome:Add(workspace.Apple)
	someTome:Connect(workspace.ChildAdded, print)
	someTome:Add(function()
		print("Tome was destroyed!")
	end)
	
	local objects = someTome:GetObjectsOfClass("function")
	print(objects) -> {[1] = function(REF)}
	```
	
	```lua
	local Tome = require(`Path`)
	local someTome = Tome.new()
	
	someTome:Add(workspace.Apple)
	someTome:Connect(workspace.ChildAdded, print)
	someTome:Tween(workspace.Cube, TweenInfo.new(5), { Size = Vector3.one })
	someTome:Tween(workspace.AnotherCube, TweenInfo.new(5), { Size = Vector3.one })
	
	local objects = someTome:GetObjectsOfClass("Tween")
	print(objects) -> {[1] = Instance(Tween,REF), [2] = Instance(Tween,REF)}
	```
	
]]
function Tome:GetObjectsOfClass(className: string) : {any}
	assert(type(className) == "string", "Tome:GetObjectsOfClass className argument must be a string type.")
	
	local objects: {[any]: any} = self.__objects
	local collectedObjects: {Instance} = {}
	
	for object: any in objects do
		local objectType: string = RealTypeOf(object)
		
		if (typeof(object) == "Instance" and object:IsA(className))
			or (objectType == className)
			or (objectType == "Tome" and className == "Tome")
			or (objectType == "Signal" and className == "Signal")
		then
			table.insert(collectedObjects, object)
		end
	end
	
	return collectedObjects
end

--[[
	
	Tome:GetObjectsWithTag(tag: string) : {[number]: any}
	
	Returns all the objects that have the provided tag. Generally this is only called
	internally, but may prove to be useful in certain cases.
	
]]
function Tome:GetObjectsWithTag(tag: string) : {any}
	assert(type(tag) == "string", "Tome:GetObjectsWithTag tag argument must be a string type.")
	
	local objects: {[any]: string} = self.__objects
	local collectedObjects: {Instance} = {}
	
	for object: any in objects do
		local isInstance: boolean = typeof(object) == "Instance"
		
		if isInstance and object:HasTag(tag) then
			table.insert(collectedObjects, object)
		end
	end
	
	return collectedObjects
end

--[[
	
	Tome:DestroyAllObjects() : ()
	
	Destroys all the objects contained within the Tome. Any objects contained with
	Pages of the Tome will not be destroyed. To destroy objects contained within
	the Pages of the Tome, Tome:Destroy is a more viable option. Generally this is
	only called internally, however in some cases this may be helpful.
	
	Will thrown an error if the Tome is in the middle of being destroyed, unless
	the ignoreDestroyingProperty argument is set to true.
	
	```lua
	local Tome = require(`Path`)
	local someTome = Tome.new()
	
	-- construct a new Page and add an "apple" object to it
	local somePage = someTome:AddPage()
	somePage:Add(workspace.Apple)
	
	-- add a "banana" object to the main Tome
	someTome:Add(workspace.Banana)
	
	-- destroys only the banana as the apple was contained within a Page
	someTome:DestroyAllObjects()
	```
	
]]


function Tome:DestroyAllObjects(__ignoreDestroyingProperty: boolean?) : ()
	if self:IsDestroying() and not __ignoreDestroyingProperty then
		error(string.format(TOME_IS_DESTROYING_ERROR_MESSAGE, "destroy all objects"))
	end
	
	local objects: {[any]: any} = self.__objects
	local objectExists: boolean = TableUtility.isEmpty(objects)
	if objectExists then
		local fastDestroy: boolean = self.__fastDestroy
		local warnings: boolean = self.__warnings
		
		if fastDestroy then
			for object: any, destroyMethod: any in objects do
				-- pseudo multithreading has its downside of instantiating a thread for every object that has to be destroyed
				-- this is currently quite slow and there are alternatives currently being looked at
				local success: boolean, result: any = pcall(task.spawn, DestroyObject, object, destroyMethod)
				
				if not success and warnings then
					FailedToDestroyObject(object, result)
				end
			end
		else
			for object: any, destroyMethod: any in objects do
				local success: boolean, result: any = pcall(DestroyObject, object, destroyMethod)
				
				if not success and warnings then
					FailedToDestroyObject(object, result)
				end
			end
		end
		
		table.clear(objects)
	end
end

--[[
	
	Tome:DestroyAllPages() : ()
	
	Destroys all the Pages contained within the Tome. Useful for when needing to destroy all the
	Pages and keep the objects in the Tome.
	
	Will thrown an error if the Tome is in the middle of being destroyed, unless
	the ignoreDestroyingProperty argument is set to true.
	
]]
function Tome:DestroyAllPages(__ignoreDestroyingProperty: boolean?) : ()
	if self:IsDestroying() and not __ignoreDestroyingProperty then
		error(string.format(TOME_IS_DESTROYING_ERROR_MESSAGE, "destroy all Pages"))
	end
	
	local pageExists: boolean = TableUtility.isEmpty(self.__pages)
	if pageExists then
		for pageName: string, page: Types.Tome in self.__pages do
			page:Destroy()
		end
	end
end

--[[
	
	Tome:DelayDestroy(duration: number) : thread
	
	Delays the Tome:Destroy method by a specified duration time. Returns a
	thread which can be cancelled to stop the destroy method from calling.
	This method will yield any thread it was invoked in.
	
	Will thrown an error if the Tome is in the middle of being destroyed.
	
	```lua
	local Tome = require(`Path`)
	local someTome = Tome.new()
	
	someTome:Add(workspace.Apple)
	
	-- destroys the apple after 2 seconds
	someTome:DelayDestroy(2)
	```
	
	```lua
	local Tome = require(`Path`)
	local someTome = Tome.new()
	
	someTome:Add(workspace.Apple)
	
	-- variablize the thread
	local thread = someTome:DelayDestroy(5)
	
	task.wait(2)
	
	-- this prevents the Tome from being destroyed as it cancels the thread
	task.cancel(thread)
	```
	
]]
function Tome:DelayDestroy(duration: number) : thread
	if self:IsDestroying() then
		error(string.format(TOME_IS_DESTROYING_ERROR_MESSAGE, "delay destroy the Tome"))
	end
	
	return task.delay(duration, self:WrapDestroy())
end



--[[
	
	Tome:WrapDestroy() : () -> ()
	
	Wraps the Tome:Destroy method into a function that is then returned. Calling the function
	will destroy the Tome.
	
	```lua
	local Tome = require(`Path`)
	local someTome = Tome.new()
	
	local destroyTome = someTome:WrapDestroy()
	
	-- destroys the Tome as normal
	destroyTome()
	```
	
]]
function Tome:WrapDestroy() : () -> ()
	return function()
		self:Destroy()
	end
end

--[[
	
	Tome:OnDestroy(callback: (...any) -> (), synchronous: boolean?) : () -> ()
	
	Inserts a callback into the destroy callbacks table of the Tome. Before the Tome is about
	to destroy all of its objects and Pages, all of the callback(s) will fire first. An additional
	argument can be provided "synchronous" which is a boolean and determines whether the callback
	should be run synchronously.
	
	This method returns a function, that when called, removed the callback from the Tome.
	The callback will *not* be removed from the Tome after it's destroyed, when a Tome becomes unused
	it's unnecessary to free this reference from memory as the collector catches it anyway.
	
	```lua
	local Tome = require(`Path`)
	local someTome = Tome.new()
	
	someTome:OnDestroy(function()
		print("The Tome is about to destroy all of its objects!")
	end)
	
	someTome:Destroy()
	```
	
	```lua
	local Tome = require(`Path`)
	local someTome = Tome.new()
	
	local unattachCallback = someTome:OnDestroy(function()
		print("The Tome is about to destroy all of its objects!")
	end)
	
	-- removes the callback from the Tome
	unattachCallback()
	
	someTome:Destroy()
	```
	
	```lua
	local Tome = require(`Path`)
	local someTome = Tome.new()
	
	someTome:OnDestroy(function()
		print("The Tome is about to destroy all of its objects!")
		
		-- this will yield the execution of the destroy method
		task.wait(3)
		
		print("And now the Tome is actually going to destroy!")
	end, true) -- set to false to prevent yielding
	
	someTome:Destroy()
	```
	
]]
function Tome:OnDestroy(callback: (...any) -> (), synchronous: boolean?, deferred: boolean?) : () -> ()
	assert(type(callback) == "function", "Tome:OnDestroy callback argument must be a function type.")
	
	if self:IsDestroying() then
		error(string.format(TOME_IS_DESTROYING_ERROR_MESSAGE, "attach a destroy callback"))
	end
	
	local callbackData: Types.CallbackData = {
		synchronous = synchronous,
		callback = callback,
		deferred = deferred,
	}
	table.insert(self.__destroyCallbacks, callbackData)
	
	return function()
		local index: number? = table.find(self.__destroyCallbacks, callbackData)
		if index then
			table.remove(self.__destroyCallbacks, index)
		end
	end
end

--[[
	
	Tome:Destroy(...any) : ()
	
	Destroys the Tome alongside any Pages and objects within it. Clears any references to
	objects and Pages within the Tome.
	
	Destroy callbacks are invoked after everything is destroyed to guarantee clarity
	Keep in mind synchronous callbacks will yield the Tome if the callback is yieldable
	To prevent callbacks from being synchronous, use `Tome:OnDestroy(callback, false)`
	
	Will throw an error if the Tome is in the middle of being destroyed.
	
	```lua
	local Tome = require(`Path`)
	local someTome = Tome.new()
	
	-- add a cube to the Tome
	someTome:Add(workspace.Cube)
	
	-- destroys the Tome, which in this case will destroy the cube
	someTome:Destroy()
	```
	
]]
function Tome:Destroy(...: any) : ()
	if self:IsDestroying() then
		error(string.format([[
			%s.
			If Tome:Destroy is invoked frequently, using Tome:CanDestroy before attempting to destroy the Tome should help.
		]], string.format(TOME_IS_DESTROYING_ERROR_MESSAGE, "destroy the Tome")))
	end
	
	self.__destroying = true
	
	self:DestroyAllObjects(true)
	self:DestroyAllPages(true)
	
	self.__destroying = false
	
	for _: number, callbackData: Types.CallbackData in self.__destroyCallbacks do
		local callback: (...any) -> () = callbackData.callback
		
		if callbackData.synchronous then
			callback(...)
		else
			task[callbackData.deferred and "defer" or "spawn"](callback, ...)
		end
	end
end

return Tome