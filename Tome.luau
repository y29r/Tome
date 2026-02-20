--!strict
--!native
-- Auth: @bytenand (Roblox) @y29r (Github)
-- Date: October 3rd, 2025
-- Deps: [Signal, Symbol]
-- A basic clean up module to handle Instances, custom classes and function clean ups.
--[[
	v1.2.c-9:
		All versions from here will now be put directly to the Github
		and all new versions will be pushed as packages with changes audited under the description.
		
		Tome.VERSION will continue to update for backwards compatability for now.
	
	v1.2.c-8:
		Adds Tome.schedule
		Implemented an internal scheduler for Tome to use in the future
		
	v1.2.c-7:
		Adds Tome.Is
			
	v1.2.c-6:
		Updated Tome:AttachTuple to return a standard clean up function, alongside the attachments array
		
	v1.2.c-5:
		Adds Tome:AttachTuple
	
	v1.2.c-4:
		Made a small optimization to Tome:Tween
		Fixed typing for Tome:SetTag
		Tome:SetTag now disconnects the tag listener connection when no tag for the Tome exists

	v1.2.c-3:
		Types can now be fetched from Tome directly.
		Resolves double requiring and reduces write count:
		```luau
		local Tome = require("../Path/To/Tome")
		local TomeTypes = require("../Path/To/Types")
		```
		Added more detailed attribute tags to methods within comments
		Fixed Tome:Instance not throwing its warning for invalid properties
		Tome:Attach now returns nil if the provided object is an instance which is unparented
		Superseded Tome:Heartbeat and Tome:RenderStepped with Tome:HookRunServiceSignal
		Improved comment documentation across all methods
		Optimized methods by preproviding destroy methods to known object types
		Removed the RemoveOnDestroy metadata for Tome:Tween
		Updated Tome:OnDestroy to use params instead of passing magic args
		Tome.version -> Tome.VERSION
		Improved performance of Tome:Move
		Renamed FastDestroy -> SpawnDestroy

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
			
			```luau
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
	Tome.Is : Checks whether the provided object is a Tome.
	Tome.schedule : Schedules an object to be destroyed after a given life time.
	
	Tome:Add : Adds an object to the Tome.
	Tome:AddTuple : Adds multiple objects to the Tome.
	Tome:AddFromArray : Adds objects from a provided array to the Tome.
	Tome:AddPromise : Adds a standard Promise to the Tome.
	Tome:AddPage : Constructs a Page (alias for Tome) and adds it to the Tome.
	Tome:Attach : Attaches the Tome to an object. When the object is destroyed, the Tome will also destroy.
	Tome:AttachTuple : Same as Tome:Attach but tuple arguments can be passed.
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
	Tome:DestroyObjectsOfType : Destroys all the objects in the Tome that have the specified type.
	Tome:Contains : Returns whether the specified object exists within the Tome.
	Tome:Has : Alias for Tome:Contains.
	Tome:FromExisting : Creates an Instance with Instance.fromExisting and adds it to the Tome.
	Tome:GetObjects : Returns all the objects contained within the Tome.
	Tome:GetObjectsWithTag : Returns all the objects contained within the Tome that contain a provided tag.
	TOme:GetObjectsOfType : Returns all the objects of a specified type name.
	Tome:GetPage : Returns a Page from the Tome given a name.
	Tome:GetParent : Gets the parent Tome (if it has one)
	Tome:GetTag : Returns the internal tag the Tome uses to automatically remove destroyed instances.
	Tome:GivePage : Moves a Page to another Tome or Page.
	Tome:HookRunServceSignal : Connects to any of the RunService signals given a name
	Tome:Instance : Creates an Instance with Instance.new and adds it to the Tome.
	Tome:IsDestroying : Returns whether the Tome is currently destroying or not.
	Tome:Move : Moves an object from the current Tome to another.
	Tome:Parent : Parents the Tome to another Tome.
	Tome:Remove : Removes an object from the Tome (not destroying it)
	Tome:RemoveTuple : Removes multiple objects from the Tome.
	Tome:RemoveFromArray : Removes objects from an array of objects from the Tome.
	Tome:RemoveObjectsWithTag : Removes objects with a specified tag from the Tome.
	Tome:RemoveObjectsOfType : Removes objects of a specified type from the Tome.
	Tome:Rename : Renames the Tome.
	Tome:RipPage : Destroys the provided page and removes it from the Tome.
	Tome:RipPages : Destroys and removes all the Pages within a Tome.
	Tome:SetTag : Overrides the default Tome tag used for Instances.
	Tome:Signal : Constructs a standard Signal class and adds it to the Tome.
	Tome:UnbindRenderStepped : Unbinds a binding made with Tome:BindRenderStepped.
	Tome:Tween : Tweens an object and adds the Tween to the Tome.
	Tome:Table : Adds a table inside the Tome and using table.clear as the destroy method
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
			'FastAdd' : boolean : Skips sanity checks when adding objects with Tome:Add
			'SpawnDestroy' : boolean : Calls the destroy method of every object in a new thread.
			'Warnings' : boolean : Whether warnings will appear in the output. Errors will not be affected.
			'Tagging' : boolean : Whether to use the tagging system for Instances.
			'UseParentMetaprops' : boolean : If this prop is true, all Pages created under the Tome will automatically define the same metaprops as its parent
				This includes deeply nested Tomes with more complex architecture.
		
		Warnings:
			Setting the Mode metaprop to one of the available values may result in unfavourable results as weak keys/values
			can be difficult to work with. It's recommended to not set this property unless you know what you're doing.
		
]]

local Types: boolean = require("./Types")

export type Tome = Types.Tome
export type Metaprops = Types.Metaprops
export type DestroyMethod = Types.DestroyMethod
export type RunServiceSignalName = Types.RunServiceSignalName
export type OnDestroyParams = Types.OnDestroyParams
export type OnDestroyCallbackData = Types.OnDestroyCallbackData
export type ObjectDictionary = Types.ObjectDictionary

export type Attachment = Types.Attachment
export type ScheduledObjectEntry = Types.ScheduledObjectEntry

local RunService: RunService = game:GetService("RunService")
local HttpService: HttpService = game:GetService("HttpService")
local TweenService: TweenService = game:GetService("TweenService")
local CollectionService: CollectionService = game:GetService("CollectionService")

local Static = require("./Static")

local TweenType = require("./TweenType")
local GuessType = require("./GuessType")
local ThreadType = require("./ThreadType")
local FunctionType = require("./FunctionType")

-- current hotfix to fix the new type solver crying about string formatting
local TOME_IS_DESTROYING_ERROR_MESSAGE: "Attempted to '%s' while the current Tome is in the middle of being destroyed."
	= "Attempted to '%s' while the current Tome is in the middle of being destroyed."

-- extension method names for classes that may be invoked on when calling Tome:Clone
local EXTENSION_METHOD_NAMES: {string} = { "clone", "Clone", "extend", "Extend" }

local Signal = require("./Signal/Signal")

local throwError = require("./throwError")
local realTypeOf = require("./realTypeOf")
local destroyObject = require("./destroyObject")
local getDestroyMethodForObject = require("./getDestroyMethodForObject")
local failedToDestroyObject = require("./failedToDestroyObject")

local Tome = {}
Tome.__index = Tome
Tome.__type = "Tome"

Tome.TweenType = TweenType
Tome.ThreadType = ThreadType
Tome.FunctionType = FunctionType

Tome.Guess = GuessType

Tome.VERSION = require("./VERSION")

-- Tome.__tostring = function(self: Tome)
-- 	local objects: {[any]: DestroyMethod} = self.__objects

-- 	local objectsPrint: string = ""
-- 	for object: any, destroyMethod: DestroyMethod in objects do
-- 		objectsPrint ..= typeof(object) .. "(" .. tostring(object) .. ")" .. ", "
-- 	end

-- 	return string.format([[

-- 		Tome(%*)
-- 		[Objects]: {%*}
-- 	]], self.__name or "Blank", objectsPrint)
-- end

local DEFAULT_SPAWN_DESTROY: boolean = Static.SpawnDestroy
local DEFAULT_FAST_ADD: boolean = Static.FastAdd
local DEFAULT_WARNINGS: boolean = Static.Warnings
local DEFAULT_TAGGING: boolean = Static.Tagging
local DEFAULT_USE_PARENT_METAPROPS: boolean = Static.UseParentMetaprops

--[[
	
	@constructor Tome.new()
	@param metaprops Metaprops
	@return Tome
	
	Constructs and returns a new Tome object.
	
	Example(s):
	```luau
	local Tome = require("../Path/To/Tome")
	local newTome = Tome.new()
	
	-- add a cube to the new Tome
	newTome:Add(workspace.Cube)
	
	-- destroys the Tome as well as the cube
	newTome:Destroy()
	```
	
]]
function Tome.new(metaprops: Types.Metaprops?) : Tome
	local FAST_ADD: boolean? = metaprops and metaprops.FastAdd
	local TAGGING: boolean? = metaprops and metaprops.Tagging
	local WARNINGS: boolean? = metaprops and metaprops.Warnings
	local SPAWN_DESTROY: boolean? = metaprops and metaprops.SpawnDestroy
	local USE_PARENT_METAPROPS: boolean? = metaprops and metaprops.UseParentMetaprops
	
	local self = setmetatable({
		__fastAdd = if type(FAST_ADD) == "boolean" then FAST_ADD else DEFAULT_FAST_ADD,
		__spawnDestroy = if type(SPAWN_DESTROY) == "boolean" then SPAWN_DESTROY else DEFAULT_SPAWN_DESTROY,
		__warnings = if type(WARNINGS) == "boolean" then WARNINGS else DEFAULT_WARNINGS,
		__tagging = if type(TAGGING) == "boolean" then TAGGING else DEFAULT_TAGGING,
		__pages = {},
		__objects = {},
		__destroying = false,
		__name = nil,
		__parent = nil,
		__useParentMetaprops = if type(USE_PARENT_METAPROPS) == "boolean" then USE_PARENT_METAPROPS else DEFAULT_USE_PARENT_METAPROPS,
		__tomeTag = (TAGGING and HttpService:GenerateGUID(false)) or nil,
		__tagRemovedConnection = nil,
		__destroyCallbacks = {},
	}, Tome) :: any
	
	return self
end

--[[
	
	@within Tome
	@param object any
	@return boolean
	
	Checks if the provided object is a Tome.
	
	Will check against the direct metatable first. If the value is equal then
	it's definitely a Tome.
	
	If the provided object is a table with a couple of Tome's methods inside
	it then it's safe to assume it's coming from another module.
	
	Example(s):
	```luau
	local Tome = require("../Path/To/Tome")
	local newTome = Tome.new()
	
	print("#1 Is this object a Tome? ", Tome.Is({})) -- false
	print("#2 Is this object a Tome? ", Tome.Is(newTome)) -- true
	print("#3 Is this object a Tome? ", Tome.Is()) -- false
	```
	
]]
function Tome.Is(object: any) : boolean
	if type(object) ~= "table" then
		return false
	end
	
	if getmetatable(object) == Tome then
		return true
	end
	
	-- these methods are from all versions of Tome, so if they exist
	-- we know that this is at least some kind of Tome.
	local usesTomeMethods: boolean = type(object.Destroy) == "function"
		and type(object.BindRenderStepped) == "function"
	
	return usesTomeMethods
end

--[[
	
	@param index number
	@param hash {Entry}
	@param indexMap {[any]: number}
	@return void
	
	Moves the entry at index upward in the heap until it reaches
	the correct position based on its expiration time.
	
	This is used after appending a new entry or updating an existing
	entry to expire sooner.
	
	If the entry expires earlier than its parent, they are swapped.
	The index map is updated on every swap so lookups remain accurate (hopefully)
	
]]
local function bubbleUpSchedule(
	index: number,
	hash: {ScheduledObjectEntry},
	indexMap: {[any]: number}
) : ()
	while index > 1 do
		local parentIndex: number = math.floor(index * 0.5)
		if hash[parentIndex].ExpiresAt <= hash[index].ExpiresAt then
			break
		end
		
		hash[parentIndex], hash[index] = hash[index], hash[parentIndex]
		
		indexMap[hash[parentIndex].Object] = parentIndex
		indexMap[hash[index].Object] = index
		
		index = parentIndex
	end
end

--[[
	
	@param index number
	@param hash {Entry}
	@param indexMap {[any]: number}
	@return void
	
	Moves the entry at index downward in the heap until both of its
	children expire later than it.
	
	This is used after removing the root or updating an entry to expire
	later than before.
	
	The entry is swapped with whichever child expires the soonest.
	The index map is updated on every swap to keep everything up to date.
	
]]
local function bubbleDownSchedule(
	index: number,
	hash: {ScheduledObjectEntry},
	indexMap: {[any]: number}
) : ()
	local hashSize: number = #hash

	while true do
		local smallestIndex: number = index
		
		local leftIndex: number = index * 2
		local rightIndex: number = leftIndex + 1
		
		if leftIndex <= hashSize and hash[leftIndex].ExpiresAt < hash[smallestIndex].ExpiresAt then
			smallestIndex = leftIndex
		end
		
		if rightIndex <= hashSize and hash[rightIndex].ExpiresAt < hash[smallestIndex].ExpiresAt then
			smallestIndex = rightIndex
		end
		
		if smallestIndex == index then
			break
		end
		
		hash[index], hash[smallestIndex] = hash[smallestIndex], hash[index]
		
		indexMap[hash[index].Object] = index
		indexMap[hash[smallestIndex].Object] = smallestIndex
		
		index = smallestIndex
	end
end

--[[
	
	@param heap {ScheduledObjectEntry}
	@return ScheduledObjectEntry
	
	Removes the earliest scheduled entry and reshifts the heap; fixing invalid indexes.
	Expectes at least one entry, and will throw an error if none exist.
	
]]
local function popRootScheduledObject(
	heap: {ScheduledObjectEntry},
	indexMap: {[any]: number}
) : ScheduledObjectEntry
	local heapSize: number = #heap
	local rootEntry: ScheduledObjectEntry = heap[1]
	
	heap[1] = heap[heapSize]
	heap[heapSize] = nil
	
	indexMap[rootEntry.Object] = nil
	
	if heapSize > 1 then
		indexMap[heap[1].Object] = 1
		
		bubbleDownSchedule(1, heap, indexMap)
	end
	
	return rootEntry
end

local Schedular = {}
Schedular.DefaultSchedularSignalName = "Heartbeat" :: RunServiceSignalName
Schedular.__stepConnection = nil :: RBXScriptConnection?

-- no point in storing these in the Schedular because they shouldn't be changed anyway
local scheduledObjectEntries: {ScheduledObjectEntry} = {}
local objectToIndexMap: {[any]: number} = {}

--[[
	
	@return void
	
	Checks the object entries hash and pops an entry if its expiration time is less (or equal) to the current time
	If no object entries exist, the schedular will stop itself from running to save resources.
	
]]
function Schedular.stepSchedular()
	local currentTime: number = os.clock()
	
	if Schedular.isScheduleEmpty() then
		Schedular.stopSchedular()
		return
	end
	
	while
		scheduledObjectEntries[1] and scheduledObjectEntries[1].ExpiresAt <= currentTime
	do
		local poppedEntry: ScheduledObjectEntry = popRootScheduledObject(scheduledObjectEntries, objectToIndexMap)
		
		destroyObject(poppedEntry.Object, poppedEntry.DestroyMethod)
	end
end

--[[
	
	@return boolean
	
	Returns whether the schedular is currently running
	
]]
function Schedular.isSchedularRunning() : boolean
	return Schedular.__stepConnection and Schedular.__stepConnection.Connected or false
end

--[[
	
	@return boolean
	
	Returns whether the schedular is empty (whether the object entries hash is empty)
	
]]
function Schedular.isScheduleEmpty() : boolean
	return #scheduledObjectEntries == 0
end

local function newSpawner() : ()
	while true do
		local callback: () -> () = coroutine.yield()
		
		callback()
	end
end

local spawner: thread = coroutine.create(newSpawner)
coroutine.resume(spawner)

--[[
	
	@param runServiceSignalName RunServiceSignalName?
	@return void
	
	Connections a RunService signal to the `Schedular.stepSchedular` function.
	Optionally you can start the schedular with a given signal name or:
	You can set the Schedular.DefaultSchedularSignalName to any RunService signal name.
	
]]
function Schedular.startSchedular(runServiceSignalName: RunServiceSignalName?) : ()
	Schedular.stopSchedular()
	
	coroutine.resume(spawner, function()
		Schedular.__stepConnection = (RunService :: any)
			[runServiceSignalName or Schedular.DefaultSchedularSignalName]:Connect(Schedular.stepSchedular)
	end)
end

--[[
	
	@return void
	
	Disconnects the schedular stopping it completely
	
]]
function Schedular.stopSchedular() : ()
	if Schedular.__stepConnection and Schedular.__stepConnection.Connected then
		Schedular.__stepConnection:Disconnect()
	end
end

Tome.Schedular = Schedular

--[[
	
	@within Tome
	@param object any
	@param lifeTime number
	@return void
	
	Schedules an object to be deleted after the given life time. Works similarly to
	`Debris:AddItem`. Any scheduled objects will also remain in the heap even if the main thread dies
	
	Example(s):
	```luau
	local Tome = require("../Path/To/Tome")
	
	Tome.schedule(workspace.Part, 2.0) -- schedules the part to be destroyed after 2 seconds
	```
	
	```luau
	local Tome = require("../Path/To/Tome")
	
	local part = Tome.schedule(workspace.Part2, 3) -- schedular uses generics to return the object afterwards for some useful cases
	
	Tome.schedule(function() -- you can insert any objects that go inside Tome as well, not just `Instance`s i.e. functions, threads, classes.
		print("hello")
	end, 2)
	
	script:Destroy() -- both the scheduled objects above will will get cleared up, even after the main thread dies
	```
	
]]
function Tome.schedule<object>(object: object, lifeTime: number, destroyMethod: DestroyMethod?) : object
	assert(type(lifeTime) == "number", "Expected argument #2 lifeTime to be a number type")
	
	if not Schedular.isSchedularRunning() then
		Schedular.startSchedular()
	end
	
	if type(object) == "table" and object.__TOME_OBJECT_GROUP__ then
		for index: number, tupleObject: any in object.Tuple do
			Tome.schedule(tupleObject, lifeTime)
		end
		
		return object
	end
	
	local currentTime: number = os.clock()
	local expirationTime: number = currentTime + lifeTime
	
	local existingObjectIndex: number = objectToIndexMap[object]
	if existingObjectIndex then
		local scheduledObjectEntry: ScheduledObjectEntry = scheduledObjectEntries[existingObjectIndex]
		
		scheduledObjectEntry.ExpiresAt = expirationTime
		
		if destroyMethod then
			scheduledObjectEntry.DestroyMethod = destroyMethod
		end
		
		bubbleUpSchedule(existingObjectIndex, scheduledObjectEntries, objectToIndexMap)
		bubbleDownSchedule(existingObjectIndex, scheduledObjectEntries, objectToIndexMap)
		
		return object
	end
	
	local scheduledEntry: ScheduledObjectEntry = {
		Object = object,
		DestroyMethod = destroyMethod or getDestroyMethodForObject(object),
		ExpiresAt = expirationTime,
	}
	
	local insertionIndex: number = #scheduledObjectEntries + 1
	
	table.insert(scheduledObjectEntries, insertionIndex, scheduledEntry)
	
	objectToIndexMap[object] = insertionIndex
	
	bubbleUpSchedule(insertionIndex, scheduledObjectEntries, objectToIndexMap)
	
	return object
end

--[[
	
	@param ... T
	@return {...T}
	
	Groups a given tuple of objects into a table, attaching a unique key to use
	across Tome.
	
	Example(s):
	```luau
	local Tome = require("../Path/To/Tome")
	
	local group: {any} = Tome.group(workspace.Part, workspace.Part2)
	
	Tome.schedule(group, 2.0)
	```
	
]]
function Tome.group<T>(...: T) : {__TOME_OBJECT_GROUP__: boolean, Tuple: {T}}
	return {
		__TOME_OBJECT_GROUP__ = true,
		Tuple = {...},
	}
end

--[[
	
	@param object<object>
	@return <object>
	
	Unschedules the provided object if it exists within the schedular.
	Removing the object doesn't clean up the object.
	
	If a group from `Tome.group` is provided all the objects within the group
	will be unscheduled.
	
	```luau
	local Tome = require("../Path/To/Tome")
	
	-- add all the parts to the schedular
	Tome.schedule(Tome.group(workspace.Part, workspace.Part2, workspace.Part3), 2)
	
	-- now remove a couple of parts and be left with one
	Tome.unschedule(Tome.group(workspace.Part, workspace.Part2))
	```
	
]]
function Tome.unschedule<object>(object: object) : object
	if type(object) == "table" and object.__TOME_OBJECT_GROUP__ then
		for index: number, tupleObject: any in object.Tuple do
			Tome.unschedule(tupleObject)
		end
		
		return object
	end
	
	local existingObjectIndex: number? = objectToIndexMap[object]
	if not existingObjectIndex then
		return object
	end
	
	local hashSize: number = #scheduledObjectEntries
	
	scheduledObjectEntries[existingObjectIndex], scheduledObjectEntries[hashSize]
		= scheduledObjectEntries[hashSize], scheduledObjectEntries[existingObjectIndex]
	
	objectToIndexMap[scheduledObjectEntries[existingObjectIndex].Object] = existingObjectIndex
	
	scheduledObjectEntries[hashSize] = nil
	objectToIndexMap[object] = nil
	
	if existingObjectIndex <= #scheduledObjectEntries then
		bubbleUpSchedule(existingObjectIndex, scheduledObjectEntries, objectToIndexMap)
		bubbleDownSchedule(existingObjectIndex, scheduledObjectEntries, objectToIndexMap)
	end
	
	return object
end

--[[
	
	@within Tome
	@param tag string?
	@return Tome
	
	Overrides the tome tag and updates any instances with the original tag. This doesn't serve much purpose, but
	perhaps in the future it may.

	Providing the tag argument with nil will remove the tag and any connections associated with that tag
	within the Tome.

	Returns the same Tome to allow recursive invoking
	
]]
function Tome:SetTag(tag: string?) : Tome
	assert(type(tag) == "string", "Tome:SetTag tag argument must be a string type.")
	
	local oldTag: string? = self:GetTag()
	if oldTag then
		for index: number, instance: Instance in CollectionService:GetTagged(oldTag) do
			instance:RemoveTag(oldTag)
			instance:AddTag(tag)
		end
	end
	
	if not tag then
		return self:__disconnectTagRemovedConnection()
	end

	self.__tomeTag = tag
	
	return self
end

--[[
	
	@within Tome
	@return string?
	
	Returns the tag the Tome uses to remove referenced instances. Typically this is only used
	internally, but this may come in helpful within the future.
	
]]
function Tome:GetTag() : string?
	return self.__tomeTag
end

--[[
	
	@within Tome
	@return void
	
	An internal method used to bind the "tag removed" connection. This method
	shouldn't be called outside this prototype.
	
]]
function Tome:__connectTagRemoved() : ()
	local tagRemovedConnection: RBXScriptConnection? = self.__tagRemovedConnection
	if tagRemovedConnection and tagRemovedConnection.Connected then
		return
	end
	
	local tag: string? = self:GetTag()
	if not tag then
		return
	end
	
	local function instanceRemoved(instance: Instance) : ()
		self.__objects[instance] = nil
		
		local objectExists: {Instance} = CollectionService:GetTagged(tag)
		if #objectExists == 0 then
			self:__disconnectTagRemovedConnection()
		end
	end
	
	self.__tagRemovedConnection = CollectionService:GetInstanceRemovedSignal(tag):Connect(instanceRemoved)
end

--[[
	
	@within Tome
	@return void
	
	An internal method used to disconnect the "tag removed" connection. This method
	shouldn't be called outside this prototype.
	
]]
function Tome:__disconnectTagRemovedConnection() : ()
	local tagRemovedConnection: RBXScriptConnection? = self.__tagRemovedConnection
	if tagRemovedConnection and tagRemovedConnection.Connected then
		tagRemovedConnection:Disconnect()
		
		self.__tagRemovedConnection = nil
	end
end

--[[
	
	@within Tome
	@param name string?
	@return Tome
	
	Renames the Tome. Throwns an error if the name argument isn't a string type, or nil.
	If the name argument provided is nil, it will erase the name property from the Tome.
	
	Typically this isn't useful and is really only used internally to manage Pages between
	other Tomes. Though useful for debugging.
	
]]
function Tome:Rename(name: string?) : Tome
	assert(type(name) == "string" or name == nil, "Tome:Rename name argument must be a string type, or nil.")
	
	self.__name = name
	
	return self
end

--[[
	
	@within Tome
	@param name string?
	@param metaprops Metaprops?
	@return Tome
	
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
	
	Example(s):
	```luau
	local Tome = require("../Path/To/Tome")
	local newTome = Tome.new()
	
	-- construct a new Page for the Tome
	local somePage = newTome:AddPage()
	
	-- add an apple to the Page
	somePage:Add(workspace.Apple)
	
	-- add a banana to the Tome
	newTome:Add(workspace.Banana)
	
	-- destroys both the apple, and banana as the Page also gets destroyed
	newTome:Destroy()
	```
	
	```luau
	local Tome = require("../Path/To/Tome")
	local newTome = Tome.new()
	
	-- construct a new Page for the Tome with a provided name
	newTome:AddPage("SomeName")
	
	-- get the Page by name
	local somePage = newTome:GetPage("SomeName")
	```
	
]]
function Tome:AddPage(name: string?, metaprops: Types.Metaprops?) : Tome
	assert(type(name) == "string" or name == nil, "Tome:AddPage name argument must be a string type, or nil.")
	
	if self:IsDestroying() then
		error(string.format(TOME_IS_DESTROYING_ERROR_MESSAGE, "add a Page to the Tome"))
	end
	
	if not name then
		name = HttpService:GenerateGUID(false)
	end
	
	local page: Tome? = self.__pages[name]
	if page then
		throwError("Attempted to add a Page that already exists with the given name.")
	end
	
	local newMetaprops: Types.Metaprops = {}
	if not metaprops and self.__useParentMetaprops then
		local FAST_ADD: boolean = self.__fastAdd
		local SPAWN_DESTROY: boolean = self.__spawnDestroy
		local WARNINGS: boolean = self.__warnings
		local TAGGING: boolean = self.__tagging
		local USE_PARENT_METAPROPS: boolean = self.__useParentMetaprops
		
		newMetaprops = {
			FastAdd = FAST_ADD,
			SpawnDestroy = SPAWN_DESTROY,
			Warnings = WARNINGS,
			Tagging = TAGGING,
			UseParentMetaprops = USE_PARENT_METAPROPS,
		}
	end
	
	local newPage: Tome = Tome.new(newMetaprops)
	newPage:Rename(name)
	newPage.__parent = self :: Tome
	
	self.__pages[name] = newPage
	
	return newPage
end

-- backwards compatability for other modules (and earlier versions of the module)
Tome.extend = Tome.AddPage
Tome.Extend = Tome.AddPage

--[[
	
	@within Tome
	@param pageToFind Tome
	@return (Tome?, Tome?)
	
	Attempts to find a particular Page with a deep search of all Pages and sub Pages.
	This is an internal method and shouldn't be used outside this prototype. Use Tome:GetPage
	to acquire a Page instead.
	
]]
function Tome:__findPage(pageToFind: Tome) : (Tome?, Tome?)
	local subPages: {any} = {}
	
	for name: string, page: Tome in self.__pages do
		if page == pageToFind then
			return page, self
		end
		
		table.insert(subPages, page)
	end
	
	for name, page: Tome in subPages do
		local pageFound: Tome? = page:__findPage(pageToFind)
		if pageFound then
			return pageFound, page
		end
	end
	
	return nil, nil
end

--[[
	
	@within Tome
	@return Tome?
	
	Returns the parent Tome of this Tome.
	
	Example(s):
	```luau
	local Tome = require("../Path/To/Tome")
	local newTome = Tome.new()
	
	local somePage = newTome:AddPage()
	
	print(newTome:GetParent()) -> ()
	print(somePage:GetParent()) -> newTome
	```
	
]]
function Tome:GetParent() : Tome?
	return self.__parent
end

--[[
	
	@within Tome
	@return Tome
	
	Returns the highest ancestor of a chain of Tomes
	
	This is an internal method that shouldn't be used outside this prototype.
	
]]
function Tome:__getLastParent() : Tome?
	local parent: Tome? = self:GetParent()
	if parent then
		local lastParent: Tome? = nil
		
		while parent ~= nil do
			lastParent = parent
			parent = parent.__parent
		end
		
		return lastParent or parent
	end
	
	return
end

--[[
	
	@within Tome
	@param nameOrPage string | Tome
	@return void
	
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
	
	Example(s):
	```luau
	local Tome = require("../Path/To/Tome")
	
	local newTome = Tome.new()
	
	local somePage = newTome:AddPage("Demonstration")
	
	print(newTome:GetPage("Demonstration")) -> Page(somePage)
	
	newTome:RipPage(somePage)
	
	print(newTome:GetPage("Demonstration")) -> nil -- the page has been completely erased
	```
	
]]
function Tome:RipPage(nameOrPage: string | Tome) : ()
	local nameOrPageType: string = realTypeOf(nameOrPage)
	assert(nameOrPageType == "string" or nameOrPageType == "Tome", "Tome:RipPage nameOrPage argument must be a string or Tome type.")
	
	if self:IsDestroying() then
		error(string.format(TOME_IS_DESTROYING_ERROR_MESSAGE, "rip Page from the Tome"))
	end
	
	if nameOrPageType == "Tome" then
		local page: Tome?, parentPage: Tome? = self:__findPage(nameOrPage)
		if not page or not parentPage then
			return throwError("Attempted to rip a Page that doesn't exist. Profiled using recursion")
		end
		
		page:Destroy()
		
		local pageName: string? = page.__name
		if pageName then
			parentPage.__pages[pageName] = nil
		end
		
		return
	end
	
	local page: Tome? = self.__pages[nameOrPage]
	if not page then
		return throwError("Attempted to rip a Page that doesn't exist. Profiled using a string")
	end
	
	self.__pages[nameOrPage] = nil
	
	page:Destroy()
end

--[[
	
	@within Tome
	@return void
	
	Rips all the Pages contained within the Tome. Useful when needing
	to dispose of Pages that don't need to occupy the Tome anymore.

	Example(s):
	```luau
	local Tome = require("../Path/To/Tome")

	local newTome = Tome.new()
	
	local somePage = newTome:AddPage("Demonstration")

	newTome:RipPages()

	print(newTome:GetPage("Demonstration")) -> nil -- the page has been completely erased
	```
	
]]
function Tome:RipPages() : ()
	self:DestroyAllPages()
	
	table.clear(self.__pages)
end

--[[
	
	@within Tome
	@param name string
	@return Tome?
	
	Attempts to return a Page from a given name. Typically useful when a Tome is shared
	among other scripts, and in some cases fetching a specific Page may be necessary.
	
	Will throw an error if the Tome is in the middle being destroyed.
	
	Example(s):
	```luau
	local Tome = require("../Path/To/Tome")

	local newTome = Tome.new()
	
	-- we need to access 'somePage' which is contained within another scope
	do
		local somePage = newTome:AddPage("Demonstration")
	end
	
	local somePage = newTome:GetPage("Demonstration")
	print(somePage) -> Page(somePage)
	```

]]
function Tome:GetPage(name: string) : Tome?
	assert(type(name) == "string", "Attempted to acquire a Page, however the name argument provided wasn't a string type")
	
	if self:IsDestroying() then
		error(string.format(TOME_IS_DESTROYING_ERROR_MESSAGE, "get a Page"))
	end
	
	return self.__pages[name]
end

--[[

	@within Tome
	@param newTome Tome?
	@return Tome
	
	Parents the Tome to another Tome is provided.
	If no Tome for the new parent is provided, then the Tome will
	disassociate itself from its original parent (if any)

	Regardless of outcome, the Tome will return itself.
	
	Will throw an error if either Tome is in the middle of destroying.
	
	Example(s):
	```luau
	local Tome = require("../Path/To/Tome")

	local newTome = Tome.new()
	local someOtherTome = Tome.new()

	-- initially create a Page within newTome
	local somePage = newTome:AddPage("Demonstration")

	print(newTome:GetPage("Demonstration")) -> Page(somePage)
	print(someOtherTome:GetPage("Demonstration")) -> nil

	-- at some point you may want to move the Page to another Tome or Page:
	somePage:Parent(someOtherTome)

	print(newTome:GetPage("Demonstration")) -> nil
	print(someOtherTome:GetPage("Demonstration")) -> Page(somePage)
	```

]]
function Tome:Parent(newTome: Tome?) : Tome
	local isTome: boolean = realTypeOf(newTome) == "Tome"
	assert(isTome or newTome == nil, "Tome:Parent newTome argument must be a Tome type, or nil.")
	
	if self:IsDestroying() then
		error(string.format(TOME_IS_DESTROYING_ERROR_MESSAGE, "parent a Tome"))
	end
	
	if newTome and newTome:IsDestroying() then
		throwError("Cannot add the current Tome to the newTome because the new Tome is in the middle of being destroyed.", "Ensure the new Tome is not destroying with Tome:IsDestroying.")
	end
	
	local parent: Tome? = self.__parent
	if parent then
		self.__parent = nil
		
		parent.__pages[self.__name] = nil
	end
	
	if newTome then
		newTome.__pages[self.__name] = self
		
		self.__parent = newTome
	end
	
	return self
end

--[[
	
	@within Tome
	@param pageName string
	@param newTome Tome
	@return Tome
	
	Will attempt to find a Page with the provided page name. If a Page is found
	then the Page will parent itself to the new provided parent.

	If a Page doesn't exist, nothing will happen.
	
	Example(s):
	```luau
	local Tome = require("../Path/To/Tome")

	local newTome = Tome.new()
	local someOtherTome = Tome.new()

	local somePage = newTome:AddPage("Demonstration")

	newTome:GivePage("Demonstration", someOtherTome)
	```

]]
function Tome:GivePage(pageName: string, newTome: Tome) : ()
	assert(type(pageName) == "string", "Expected argument #1 to be a string type.")
	assert(realTypeOf(newTome) == "Tome", "Expected argument #2 to be a Tome type.")
	
	local page: Tome? = self:GetPage(pageName)
	if not page then
		return
	end
	
	page:Parent(newTome)
end

--[[
	
	@within Tome
	@param object<any>
	@param otherTome Tome
	@return object<any>
	
	New: The type of the parsed object will remain, meaning type annotations
	will now be present even after internal addition
	
	Moves an object from the current Tome to another Tome and returns the
	object that was provided.
	
	Will throw an error if the Tome is in the middle of being destroyed.
	
	Example(s):
	```luau
	local Tome = require("../Path/To/Tome")
	local newTome = Tome.new()
	local someOtherTome = Tome.new()
	
	local apple = workspace.Apple
	newTome:Add(apple)
	
	print(newTome:Contains(apple)) -- true
	
	-- move the apple to the other Tome
	newTome:Move(apple, someOtherTome)
	
	print(newTome:Contains(apple)) -- false
	print(someOtherTome:Contains(apple)) -- true
	```
	
]]
function Tome:Move<object>(object: object, otherTome: Tome) : object
	local parentIsTome: boolean = realTypeOf(otherTome) == "Tome"
	if not parentIsTome then
		throwError("Tome:Move otherTome argument must be a Tome.", "Ensure the provided 'otherTome' argument is a Tome.")
	end
	
	if self:IsDestroying() then
		error(string.format(TOME_IS_DESTROYING_ERROR_MESSAGE, "move object to another Tome"))
	end
	
	local destroyMethod: DestroyMethod? = self.__objects[object]
	if not destroyMethod then
		return object
	end
	
	self:Remove(object)
	otherTome:Add(object, destroyMethod)
	
	return object
end

--[[
	
	@param object any
	@param tome Tome
	@return void
	
	Validates the given object and sanitizes it against the given Tome.
	This it not used as a method in Tome to improve performance as indexing is
	signficantly slower with metatables (especially double-indexing)
	
	TODO: Expose this function as a "validity" function to check if an object
	is able to be added into the Tome.
	
]]
local function validateObject(object: any, tome: Tome) : ()
	local objectType: string = realTypeOf(object)
	local objectIsTome: boolean = objectType == "Tome"
	if objectIsTome then
		if object == tome then
			throwError("Attempted to add current Tome (self) to the current Tome (self) Upon calling :Destroy, indefinite recursion will occur", "Ensure that the Tome isn't added into itself.")
		end
		
		local lastParent: Tome? = tome:__getLastParent()
		if lastParent == object then
			throwError("Attempted to add a Tome which is an ancestor Tome of the current Tome (self)", "Ensure no ancestor Tomes are added to the Tome.")
		end
	end
	
	-- not reusing 'objectType' for strict type compliancy
	if typeof(object) == "Instance" and not object:IsA("Tween") and tome.__tagging then
		if not object:IsDescendantOf(game) then
			throwError([[
				Attempted to add an already destroyed object to the Tome. If you are adding an Instance that hasn't been parented yet
				This error will persist. Consider turning off Tagging via Tome.new({ Tagging = false }) or setting it to false globally:
				Tome.luau -> Static.luau -> Tagging = false,
			]])
		end
		
		-- tomeTag will only have a string if tagging was enabled during instantiation
		-- if somewhere down the line metaprops can be updated after instantiation
		-- this code will need to be updated to comply
		local tomeTag: string? = tome:GetTag()
		if tomeTag then
			object:AddTag(tomeTag)
		end
		
		tome:__connectTagRemoved()
	end
end

--[[
	
	@within Tome
	@param object<any>
	@param destroyMethod DestroyMethod
	@return object<any>
	
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
	
	Example(s):
	```luau
	local Tome = require("../Path/To/Tome")
	local newTome = Tome.new()
	
	local cube = newTome:Add(workspace.Cube)
	
	-- will destroy the cube
	newTome:Destroy()
	```
	
	```luau
	local Tome = require("../Path/To/Tome")
	local newTome = Tome.new()
	
	-- Giving in a custom destroy method, in this case "Destroy"
	-- which will be called on the cube as a function
	local cube = newTome:Add(workspace.Cube, "Destroy")
	
	-- will destroy the cube
	newTome:Destroy()
	```
	
	```luau
	local Tome = require("../Path/To/Tome")
	local newTome = Tome.new()
	
	-- Giving in another custom method, in this case a function.
	-- This function will be called when the Tome is destroyed,
	-- giving in the object as the first argument to allow you to destroy the object however you like
	local cube = newTome:Add(workspace.Cube, function(cube: BasePart)
		cube:Destroy()
	end)
	
	-- will destroy the cube
	newTome:Destroy()
	```
	
]]
function Tome:Add<object>(object: object, destroyMethod: Types.DestroyMethod?) : object
	if self:IsDestroying() then
		error(string.format(TOME_IS_DESTROYING_ERROR_MESSAGE, "add an object"))
	end
	
	if not self.__fastAdd then
		validateObject(object, self)
	end
	
	self.__objects[object] = destroyMethod or getDestroyMethodForObject(object)
	
	return object
end

--[[
	
	@within Tome
	@param dictionary<ObjectDictionary>
	@return dictionary<ObjectDictionary>
	
	Adds objects into the Tome from a provided dictionary.
	Where the key(s) will be the object(s) and the value(s) will be the destroy method
	If you don't know the destroy method and want Tome to detect it automatically
	Use `Tome.Guess` for the value.
	
	Example(s):
	```luau
	local newTome: Tome.Tome = Tome.new()
	
	newTome:AddFromDictionary({
		[workspace.Part] = Tome.Guess,
		[workspace.Part2] = "Destroy",
	})
	
	newTome:DelayDestroy(2.0)
	```
	
]]
function Tome:AddFromDictionary(dictionary: ObjectDictionary) : ObjectDictionary
	if self:IsDestroying() then
		error(string.format(TOME_IS_DESTROYING_ERROR_MESSAGE, "add dictionary of objects"))
	end
	
	assert(type(dictionary) == "table", "Expected argument #1 dictionary to be a table type")
	
	local FAST_ADD: boolean = self.__fastAdd
	
	if FAST_ADD then
		for object: any, destroyMethod: DestroyMethod | {name: string} in dictionary do
			validateObject(object, self)
			
			self.__objects[object] = destroyMethod == GuessType
				and getDestroyMethodForObject(object) or destroyMethod
		end
	else
		for object: any, destroyMethod: DestroyMethod | {name: string} in dictionary do
			self.__objects[object] = destroyMethod == GuessType
				and getDestroyMethodForObject(object) or destroyMethod
		end
	end
	
	return dictionary
end

--[[
	
	@within Tome
	@param object any
	@param middleware (object: any, complete: () -> ()) -> ()
	@param destroyMethod DestroyMethod?
	@return object any
	
	*Adds* the object to the Tome in a way that allows a middleware function to run before the object is destroyed
	Once a middleware has been added, there is no way to remove it. The only time the middleware is removed is during
	the Tome's destroying life cycle.
	
	Yielding is allowed but not recommended as it will delay other objects from being destroyed.
	
	Will throw an error if the Tome is in the middle of being destroyed.
	
	Example(s):
	```luau
	local newTome = Tome.new()
	
	-- the code below will add the part to the Tome, but before the part is destroyed
	-- the part will scale up and then wait 3 seconds before calling the main destroy
	newTome:AddWithMiddleware(workspace.Part, function(object: Part, complete: () -> ())
		object.Size = Vector3.one * 4
		
		task.delay(3, complete)
	end)
	```
	
]]
function Tome:AddWithMiddleware<object>(object: object, middleware: (object: object, complete: () -> ()) -> (), destroyMethod: Types.DestroyMethod?) : object
	if self:IsDestroying() then
		error(string.format(TOME_IS_DESTROYING_ERROR_MESSAGE, "add with middleware to the Tome"))
	end
	
	self:FastAdd(function()
		middleware(object, function()
			destroyMethod = destroyMethod or getDestroyMethodForObject(object)
			
			if destroyMethod then
				destroyObject(object, destroyMethod)
			end
		end)
	end, FunctionType)
	
	return object
end

--[[
	
	@within Tome
	@param object<any>
	@param destroyMethod DestroyMethod
	@return object<any>
	
	Adds an object into the Tome while bypassing all sanity checks.
	This includes checking whether the Tome is being destroyed, and all meta props
	
	This method is now free to use in Prod-envs. There are a few caveats, but generally
	it's safe to use.
	
]]
function Tome:FastAdd<object>(object: object, destroyMethod: Types.DestroyMethod?) : object
	self.__objects[object] = destroyMethod or getDestroyMethodForObject(object)
	
	return object
end

--[[
	
	@within Tome
	@param object<...>
	@return object<...>
	
	New: The type of the parsed objects will remain, meaning type annotations
	will now be present even after internal addition
	
	Adds tuple objects to the Tome in the order they were given. After all the objects
	have been inserted, the objects will be returned in to the order they were given.
	
	Will throw an error if the Tome is in the middle of being destroyed.
	
	Example(s):
	```luau
	local Tome = require("../Path/To/Tome")
	local newTome = Tome.new()
	
	-- adds the apple, banana and pear to the Tome
	local apple, banana, pear = newTome:AddTuple(workspace.Apple, workspace.Banana, workspace.Pear)
	
	-- will destroy the apple, banana and pear
	newTome:Destroy()
	```
	
]]
function Tome:AddTuple<object...>(...) : object...
	if self:IsDestroying() then
		error(string.format(TOME_IS_DESTROYING_ERROR_MESSAGE, "add tuple objects to the Tome"))
	end
	
	local FAST_ADD: boolean = self.__fastAdd
	
	if FAST_ADD then
		for index: number, object: any in {...} do
			validateObject(object, self)
			
			self.__objects[object] = getDestroyMethodForObject(object)
		end
	else
		for index: number, object: any in {...} do
			self.__objects[object] = getDestroyMethodForObject(object)
		end
	end
	
	return ...
end

--[[
	
	@within Tome
	@param objectsArray<{any}>
	@return objectsArray<{any}>
	
	Iterates over the provided objects and adds them to the Tome.
	
	Will throw an error if the Tome is in the middle of being destroyed.
	
	Example(s):
	```luau
	local Tome = require("../Path/To/Tome")
	local newTome = Tome.new()
	
	local objectsToAdd = {workspace.Apple, workspace.Banana, workspace.Pear}
	
	-- adds the apple, banana and pear to the Tome
	local returnedObjects = newTome:AddFromArray(fruits)
	
	-- will destroy the apple, banana and pear
	newTome:Destroy()
	```
	
]]
function Tome:AddFromArray<objectsArray>(objectsArray: objectsArray) : objectsArray
	assert(type(objectsArray) == "table", "Expected argument #1 objectsArray to be a table type.")
	
	if self:IsDestroying() then
		error(string.format(TOME_IS_DESTROYING_ERROR_MESSAGE, "add objects from array"))
	end
	
	local FAST_ADD: boolean = self.__fastAdd
	
	if FAST_ADD then
		for index: number, object: any in objectsArray do
			validateObject(object, self)
			
			self.__objects[object] = getDestroyMethodForObject(object)
		end
	else
		for index: number, object: any in objectsArray do
			self.__objects[object] = getDestroyMethodForObject(object)
		end
	end
	
	return objectsArray
end

--[[
	
	@within Tome
	@param promise Promise
	@return Promise
	
	Adds a standard Promise to the Tome.
	
	Will throw an error if the Promise has already finished executing.
	Will throw an error if the Tome is in the middle of being destroyed.
	
]]
function Tome:AddPromise(promise: Types.Promise) : Types.Promise -- any should be considered a Promise, for better auto complete make sure to type cast (promise :: Promise)
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
	
	local typedPromise: Types.Promise = promise
	
	local status: string = string.lower(typedPromise:getStatus())
	if status == "started" then
		typedPromise:finally(function()
			self.__objects[typedPromise] = nil
		end)
		
		return self:Add(typedPromise, "cancel")
	end
	
	return throwError("The provided Promise has already finished executing.", "Ensure the provided Promise is still active.")
end

--[[
	
	@within Tome
	@param object<any>
	@return object<any>
	
	New: The type of the parsed object will remain, meaning type annotations
	will now be present even after internal addition.
	
	Removes an object from the Tome. The provided object will be become unreferenced
	in the Tome and will be unable to be destroyed by the Tome. If the object is an
	Instance, the tag the Tome uses will be removed from the object.
	
	Will throw an error if the Tome is in the middle of being destroyed.
	
	Example(s):
	```luau
	local Tome = require("../Path/To/Tome")
	local newTome = Tome.new()
	
	local cube = newTome:Add(workspace.Cube)
	
	-- remove the cube from the Tome
	newTome:Remove(cube)
	
	-- will not destroy the cube as it was removed before the Tome was destroyed.
	newTome:Destroy()
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
	
	@within Tome
	@param object<any>
	@return object<any>
	
	Removes an object from the Tome. Bypassing any checks. Generally this is only
	used internally and shouldn't be used outside this scope.
	
]]
function Tome:__remove<object>(object: object) : object
	self.__objects[object] = nil
	
	return object
end

--[[
	
	@within Tome
	@param ... object<any>
	@return ... object<any>
	
	New: The type of the parsed objects will remain, meaning type annotations
	will now be present even after internal addition.
	
	Removes tuple objects from the Tome. Functions exactly the same as Tome:Remove
	with the only difference being that tuple objects can be passed.
	
	Will throw an error if the Tome is in the middle of being destroyed.
	
	Example(s):
	```luau
	local Tome = require("../Path/To/Tome")
	local newTome = Tome.new()
	
	local apple, banana, pear = newTome:AddTuple(workspace.Apple, workspace.Banana, workspace.Pear)
	
	-- don't include the pear
	newTome:RemoveTuple(apple, banana)
	
	-- will only destroy the pear, as the apple and the banana were removed from the Tome
	newTome:Destroy()
	```
	
]]
function Tome:RemoveTuple<object...>(...) : object...
	if self:IsDestroying() then
		error(string.format(TOME_IS_DESTROYING_ERROR_MESSAGE, "remove tuple objects"))
	end
	
	for index: number, object: any in {...} do
		self:Remove(object)
	end
	
	return ...
end

--[[
	
	@within Tome
	@param objectsArray<{any}>
	@return objectsArray<{any}>
	
	New: The type of the parsed array will remain, meaning type annotations
	will now be present even after internal addition.
	
	Removes objects contained within a provided array from the Tome. The objectArray argument
	must be an array and must not contain any nils or incorrect index increments.
	
	Will throw an error if the Tome is in the middle of being destroyed.
	
	Example(s):
	```luau
	local Tome = require("../Path/To/Tome")
	local newTome = Tome.new()
	
	local objects = {workspace.Apple, workspace.Banana, workspace.Pear}
	
	-- adds the apple, banana and pear
	newTome:AddFromArray(objects)
	
	-- removes the apple, banana and pear
	newTome:RemoveFromArray(objects)
	
	-- destroys the Tome, and no objects get destroyed
	newTome:Destroy()
	```
	
]]
function Tome:RemoveFromArray<objectsArray>(objectsArray: objectsArray) : objectsArray
	assert(type(objectsArray) == "table", "Tome:RemoveFromArray objectArray argument must be a table type.")
	
	if self:IsDestroying() then
		error(string.format(TOME_IS_DESTROYING_ERROR_MESSAGE, "remove objects from array"))
	end
	
	for index: number, object: any in objectsArray do
		self:Remove(object)
	end
	
	return objectsArray
end

--[[
	
	@within Tome
	@param tag string
	@return void
	
	Removes objects from the Tome that contain a specified tag.
	
	Will throw an error if the Tome is in the middle of being destroyed.
	
	Example(s):
	```luau
	local Tome = require("../Path/To/Tome")
	local newTome = Tome.new()
	
	-- add a tag to the cube
	local cube = workspace.Cube
	cube:AddTag("SomeTag")
	
	-- add the cube to the Tome
	newTome:Add(cube)
	
	-- will remove the cube as it contains the "SomeTag" tag
	newTome:RemoveObjectsWithTag("SomeTag")
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
	
	@within Tome
	@param typeName string
	@return void
	
	Removes any objects that match the provided type.
	If a table contains a __type key and the value of that key is equal to the type name
	the object will be seen as removable.
	
	Will throw an error if the Tome is in the middle of being destroyed.
	
	Example(s):
	```luau
	local Tome = require("../Path/To/Tome")
	local newTome = Tome.new()
	
	local cube = workspace.Cube -- "Part"
	local someModel = workspace.SomeModel -- "Model"
	
	-- add the objects to the Tome
	newTome:AddTuple(cube, someModel)
	
	-- remove the objects that are a "Model"
	newTome:RemoveObjectsOfType("Model")
	
	-- destroys only the cube as the "someModel" object was removed prior because it was a model
	newTome:Destroy()
	```
	
]]
function Tome:RemoveObjectsOfType(typeName: string) : ()
	assert(type(typeName) == "string", "Expected argument #1 to be a string.")
	
	if self:IsDestroying() then
		error(string.format(TOME_IS_DESTROYING_ERROR_MESSAGE, "remove objects of class"))
	end
	
	local objectsOfType: {any} = self:GetObjectsOfType(typeName)
	
	self:RemoveFromArray(objectsOfType)
end

--[[
	
	@within Tome
	@param signal RBXScriptSignal | {Connect: () -> ()}
	@param listener (...any) -> ...any
	@return RBXScriptConnection | {Disconnect: () -> ()}
	
	Connects a listener function to a RBXScriptSignal or custom Signal.
	
	Will throw an error if the Tome is in the middle of being destroyed.
	
	Example(s):
	```luau
	local Tome = require("../Path/To/Tome")
	local newTome = Tome.new()
	
	local Players = game:GetService("Players")
	
	local function playerAdded(player: Player)
		print(string.format("Welcome! %s", player.DisplayName))
	end
	
	-- connects the playerAdded function to the Players.PlayerAdded signal
	newTome:Connect(Players.PlayerAdded, playerAdded)
	
	task.wait(5)
	
	-- and then destroy the Tome which removes the connection
	-- which doesn't welcome any more players :(
	newTome:Destroy()
	```
	
]]
function Tome:Connect(signal: any, listener: (...any) -> ...any) : any
	if self:IsDestroying() then
		throwError(string.format(TOME_IS_DESTROYING_ERROR_MESSAGE, "connect to a signal"))
	end
	
	local realType: string = typeof(signal)
	if realType == "RBXScriptSignal" then
		return self:FastAdd(signal:Connect(listener), "Disconnect" :: DestroyMethod?)
	end
	
	return self:FastAdd(signal:Connect(listener), nil)
end

--[[
	
	@within Tome
	@param signal RBXScriptSignal | {Connect: () -> ()}
	@param listener (...any) -> ...any
	@return RBXScriptConnection | {Disconnect: () -> ()}
	
	Connects a listener function once to a RBXScriptSignal or custom Signal.
	Once invoked, the connection will be automatically disconnected, but will
	remaing within the Tome until Tome:Destroy is called.
	
	Will throw an error if the Tome is in the middle of being destroyed.
	
	Example(s):
	```luau
	local Tome = require("../Path/To/Tome")
	local newTome = Tome.new()
	
	local Players = game:GetService("Players")
	
	local function playerAdded(player: Player) : ()
		print(string.format("The first player to join was: %*", player.Name))
	end
	
	-- connects the playerAdded function to the Players.PlayerAdded signal
	-- once a player joins, the connection will disconnect
	newTome:Once(Players.PlayerAdded, playerAdded)
	```
	
]]
function Tome:Once(signal: RBXScriptSignal, listener: (...any) -> (...any)) : any
	if self:IsDestroying() then
		throwError(string.format(TOME_IS_DESTROYING_ERROR_MESSAGE, "connect once to a signal"))
	end
	
	local realType: string = typeof(signal)
	if realType == "RBXScriptSignal" then
		return self:FastAdd(signal:Once(listener), "Disconnect" :: DestroyMethod?)
	end
	
	return self:FastAdd(signal:Once(listener), nil)
end

--[[
	
	@within Tome
	@param class {new: () -> ()} | () -> ()
	@param ... any
	@return any
	
	Constructs the provided class as if calling Class.new. Accepts both the class and
	class function. After the class argument, tuple arguments can be provided which
	will be passed into the constructed class. If neither a constructor function or
	class is provided, an error will be thrown. If the construction of the class is a
	success, the constructed class will be returned.
	
	Will throw an error if the Tome is in the middle of being destroyed.
	
	Example(s):
	```luau
	local Tome = require("../Path/To/Tome")
	local SomeClass = require("../Path/To/Tome")
	
	local newTome = Tome.new()
	
	local class = newTome:Construct(SomeClass, "Apple", "Banana", "Pear")
	
	-- will destroy the class object
	newTome:Destroy()
	```
	
	```luau
	local Tome = require("../Path/To/Tome")
	local SomeClass = require("../Path/To/Tome")
	
	local newTome = Tome.new()
	
	-- using the class constructor function as the first argument
	local class = newTome:Construct(SomeClass.new, "Apple", "Banana", "Pear")
	
	-- will destroy the class object
	newTome:Destroy()
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
	
	throwError([[Attempted to construct a new class with Tome:Construct,
		however the class provided was not a class containing a .new function.
		Only a function or a table containing a .new function is allowed]])
	
	return
end

--[[
	
	@within Tome
	@return Tome
	
	Duplicated the current Tome. The duplicate will include the same metadata and objects. To avoid
	copying over the metadata and objects, Tome:Clone is a better alternative.
	
	Example(s):
	```luau
	local Tome = require("../Path/To/Tome")
	local SomeClass = require("../Path/To/Tome")
	
	local newTome = Tome.new()
	
	-- add the apple to the Tome
	newTome:Add(workspace.Apple)
	print(newTome:Has(workspace.Apple)) -> true
	
	-- duplicate the Tome
	local duplicateTome = newTome:Duplicate()
	print(duplicateTome:Has(workspace.Apple)) -> true
	
	-- destroys the apple as it existed within the duplicate Tome
	duplicateTome:Destroy()
	
	-- prints false because the apple was destroyed by the duplicate Tome
	print(newTome:Has(workspace.Apple)) -> false
	```
	
]]
function Tome:Duplicate() : Tome
	if self:IsDestroying() then
		error(string.format(TOME_IS_DESTROYING_ERROR_MESSAGE, "duplicate the Tome"))
	end
	
	local duplicateTome: Tome = Tome.new({
		FastAdd = self.__fastAdd,
		SpawnDestroy = self.__spawnDestroy,
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
	
	@within Tome
	@param object any
	@param extendFunctionName string?
	@return any
	
	Clones the provided object and adds it to the Tome. The provided object must be
	and Instance or class containing a function with the name of one of the extension
	method names. If a class is provided and an extension function isn't found, an
	error will be thrown. If an Instance is provided, the :Clone method will be used
	on it and the clone will be added to the Tome. If neither is provided, an error
	will be thrown.
	
	Will throw an error if the Tome is in the middle of being destroyed.
	
	Example(s):
	```luau
	local Tome = require("../Path/To/Tome")
	local newTome = Tome.new()
	
	local duplicateCube = newTome:Clone(workspace.Cube)
	
	-- will destroy the duplicate cube
	newTome:Destroy()
	```
	
	```luau
	local Tome = require("../Path/To/Tome")
	local SomeClass = require("../Path/To/Tome")
	
	local newTome = Tome.new()
	
	local class = newTome:Construct(SomeClass.new)
	local duplicateClass = newTome:Clone(class)
	
	-- both the class and duplicate class will be destroyed
	newTome:Destroy()
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
			return self:FastAdd(extensionFunction(object), nil :: DestroyMethod?)
		end
		
		for index: number, extensionName: string in EXTENSION_METHOD_NAMES do
			local extension: ((object: any) -> ())? = object[extensionName]
			if extension then
				return self:FastAdd(extension(object), nil)
			end
		end
		
		return throwError("Attempted to clone a table (most likely a class) however the table doesn't contain an extension/clone method.", "Ensure the provided class has en extension method. If it does, add it to the extension list at the top of the module.")
	elseif objectType == "Instance" then
		return self:Add(object:Clone(), "Destroy")
	end
	
	error(string.format("Failed to clone object: %s", tostring(object)))
end

do
	local FORMAT_STRING: string = "\n\tAttempted to set property '%s' to an Instance created by Tome.\n\tReason: %*"
	
	--[[
		
		@within Tome
		@param instanceName string
		@param properties {[string]: any}?
		@return Instance
		
		Creates an Instance from the provider instanceName argument. Note that that instantiation
		is not invoked in protected mode. This means instantiation instances that do not exist
		will throw an error
		
		Optionally you can pass in a properties dictionary ([property] = value) to set them after
		instantiation. Properties that are invalid will be caught in protected mode, and will throw
		a warning if Warnings is enabled within the Tome.
		
		Optionally you can also pass in a custom destroy method as the 3rd argument.
		
		Will throw an error if the Tome is in the middle of being destroyed.
		
		Example(s):
		```luau
		local Tome = require("../Path/To/Tome")
		local newTome = Tome.new()
		
		local part = newTome:Instance("Part")
		part.Parent = workspace
		
		task.wait(2)
		
		newTome:Destroy() -- Destroys the part
		```
		
		```luau
		local Tome = require("../Path/To/Tome")
		local newTome = Tome.new()
		
		local part = newTome:Instance("Part", {
			Color = Color3.new(1, 1, 1),
			Size = Vector3.one,
			Parent = workspace,
		})
		
		task.wait(2)
		
		-- destroys the part
		newTome:Destroy()
		```
		
		```luau
		local Tome = require("../Path/To/Tome")
		local newTome = Tome.new()
		
		-- will throw an error as "Apple" isn't an actual instance type
		newTome:Instance("Apple")
		```
		
	]]
	function Tome:Instance(instanceName: string, properties: {[string]: any}?, destroyMethod: DestroyMethod?) : any
		assert(type(instanceName) == "string", "The instanceName argument must be a string type.")
		assert(type(properties) == "table" or properties == nil, "The properties argument must be a table type or nil.")
		
		if self:IsDestroying() then
			error(string.format(TOME_IS_DESTROYING_ERROR_MESSAGE, "create an Instance"))
		end
		
		local result: Instance = Instance.new(instanceName)
		if not self.__fastAdd then
			validateObject(result, self)
		end
		
		if properties then
			for property: string, value: any in properties do
				xpcall(function()
					(result :: any)[property] = value
				end, function(issue: string)
					if not self.__warnings then
						return
					end
					
					warn(string.format(FORMAT_STRING, tostring(property), issue))
				end)
			end
		end
		
		self.__objects[result] = destroyMethod or "Destroy"
		
		return result
	end
end


--[[
	
	@within Tome
	@param instance Instance
	@return Instance
	
	Clones the provided instance using Instance.fromExisting:
	https://create.roblox.com/docs/reference/engine/datatypes/Instance#fromExisting

	The instance will copy all properties, attributes and tags.
	Descendants will not copy over.
	
	Optionally you can also pass in a custom destroy method as the 3rd argument.
	
	Will throw an error if the Tome is in the middle of being destroyed.
	
]]
function Tome:FromExisting(instance: Instance, destroyMethod: DestroyMethod?) : any
	assert(typeof(instance) == "Instance", "Expected argument #1 'instance' to be an Instance type.")
	
	if self:IsDestroying() then
		error(string.format(TOME_IS_DESTROYING_ERROR_MESSAGE, "create an Instance from existing"))
	end
	
	local fromExisting: Instance = Instance.fromExisting(instance)
	if not self.__fastAdd then
		validateObject(fromExisting, self)
	end
	
	self.__objects[fromExisting] = destroyMethod or "Destroy"
	
	return fromExisting
end

--[[
	
	@within Tome
	@param object any
	@return (() -> ()) | RBXScriptConnection | Signal.Connection
	
	Attaches an object to the Tome. If the object is an Instance, the Destroying Signal of
	the Instance will be listened for, and once it's fired, the Tome will destroy itself.
	
	If the object is a Tome, then a wrapper destroy function will be appended to the Tome.
	
	If the object is a table that contains a :Connect method, then a listener function will connect to it and
	upon the listener being fired, the Tome will destroy itself.
	
	A clean up function unrelated/ appended to the Tome is returned after attaching.
	When the clean up function is called, the connections that consider whether an Instance is
	still preset within the datamodel will be disconnected.
	
	Keep in mind that the clean up function is manually passed into the Tome, if this behaviour
	is unpreferred then invoke Tome:RemoveObject with the clean up function as the only argument.
	
	Will throw an error if the object provided could not be attached to the Tome.
	
	Example(s):
	```luau
	local Tome = require("../Path/To/Tome")
	local newTome = Tome.new()
	
	local cube = workspace.Cube
	
	-- attach the Tome to the cube
	newTome:Attach(cube)
	
	-- will also destroy the Tome, as the Tome attached to the cube
	cube:Destroy()
	```
	
]]
function Tome:Attach(object: any) : (() -> ()) | RBXScriptConnection | Signal.Connection?
	local objectType: string = realTypeOf(object)
	
	if objectType == "Tome" then
		return object:Add(self:WrapDestroy(), FunctionType)
	elseif objectType == "Instance" then
		if not object:IsDescendantOf(game) then
			return
		end
		
		-- bad up values should be changed at some point
		local wasDestroyed: boolean = false
		local wasNulled: boolean = false
		
		local destroyingConnection: RBXScriptConnection = object.Destroying:Connect(function()
			if wasDestroyed or wasNulled then
				return
			end
			
			wasDestroyed = true
			
			self:Destroy()
		end)
		
		local ancestryConnection: RBXScriptConnection = object.AncestryChanged:Connect(function()
			local descendantOfGame: boolean = object:IsDescendantOf(game)
			if descendantOfGame then
				return
			end
			
			if wasDestroyed or wasNulled then
				return
			end
			
			wasNulled = true
			
			self:Destroy()
		end)
		
		return self:FastAdd(function()
			if destroyingConnection.Connected then
				destroyingConnection:Disconnect()
			end
			
			if ancestryConnection.Connected then
				ancestryConnection:Disconnect()
			end
		end, FunctionType)
	elseif objectType == "Signal"
		or (objectType == "table" and type(object.Connect) == "function")
		or objectType == "RBXScriptSignal"
	then
		return object:Connect(self:WrapDestroy())
	end
	
	return throwError(string.format("Could not attach object: %* to Tome.", object), "Ensure the provided object is either a Tome, Signal, Instance or class with a :Connect method.")
end

--[[

	@within Tome
	@param ...any
	@return () -> (), {Attachment}
	
	Takes in tuple object arguments which are then passed through self:Attach(object)
	each result added to an array. After iteration, a clean up function and *attachment* array will be returned
	
	The array consists of either connections or functions based on the objects passed in
	The order of the *attachments* will always be the same as the order the tuple was passed with
	The array is immutable.
	
	When the clean up function is called, all the attachments will be cleaned up and disposed of properly.
	
	Tome doesn't automatically add the clean up function into itself, if you need that behaviour, wrap
	the clean up function as such:
	```luau
	local cleanUp: () -> () = newTome:AttachTuple(workspace.Cube, workspace.Cube2)
	newTome:FastAdd(cleanUp, Tome.FunctionType)
	```
	
	Example(s):
	```luau
	local Tome = require("../Path/To/Tome")
	local newTome = Tome.new()
	
	newTome:AttachTuple(workspace.Cube, workspace.Cube2)
	newTome:Add(function()
		print("Either cube, or cube2 was destroyed!")
	end)
	
	workspace.Cube2:Destroy()
	```
	
	```luau
	local Tome = require("../Path/To/Tome")
	local newTome = Tome.new()
	
	-- use the variable to get the attachments
	local cleanUpAttachments: () -> () = newTome:AttachTuple(workspace.Cube, workspace.Cube2)
	
	newTome:Add(function()
		print("Either cube, or cube2 was destroyed!")
	end)
	
	cleanUpAttachments() -- clean up all the attachments, freeing any from the Tome as well
	
	-- nothing will happen since the attachments were cleaned up
	workspace.Cube:Destroy()
	workspace.Cube2:Destroy()
	```
	
	```luau
	local Tome = require("../Path/To/Tome")
	local newTome = Tome.new()
	
	-- use the variable to get the attachments
	local cleanUpAttachments: () -> (), attachments: {any} = newTome:AttachTuple(workspace.Cube, workspace.Cube2)
	
	newTome:Add(function()
		print("Either cube, or cube2 was destroyed!")
	end)
	
	attachments[1]:Disconnect() -- since cube is an instance, this will be a connection, so let's disconnect it
	
	-- destroy the cube and nothing will happen as we disconnected that specific attachemtn
	workspace.Cube:Destroy()
	```
	
]]
function Tome:AttachTuple(...: any) : (() -> (), {Attachment})
	local attachments: {Attachment} = self:Table({})
	
	for index: number, object: any in {...} do
		table.insert(attachments, self:Attach(object))
	end
	
	return function()
		for index: number, attachment: Attachment in attachments do
			if type(attachment) == "function" then
				attachment()
			elseif typeof(attachment) == "RBXScriptConnection" or (type(attachment) == "table" and attachment.Connected and attachment.Disconnect) then
				if attachment.Connected then
					(attachment :: any):Disconnect()
				end
			end
		end
		
		self:RemoveFromArray(attachments)
	end, table.freeze(attachments)
end

--[[
	
	@within Tome
	@param tag string
	@return void
	
	Destroys all the objects contained within the Tome that have the provided tag.
	
	Will throw an error if the Tome is in the middle of being destroyed.
	
	Example(s):
	```luau
	local Tome = require("../Path/To/Tome")
	local newTome = Tome.new()
	
	local apple, banana, pear = workspace.Apple, workspace.Banana, workspace.Pear
	
	-- add all the fruits
	newTome:AddTuple(apple, banana, pear)
	
	-- tag only the apple and banana
	apple:AddTag("SomeTag")
	banana:AddTag("SomeTag")
	
	-- destroys only the apple and banana. The pear remains as it wasn't tagged
	newTome:DestroyObjectsWithTag("SomeTag")
	```
	
]]
function Tome:DestroyObjectsWithTag(tag: string) : ()
	assert(type(tag) == "string", "Tome:DestroyObjectsWithTag tag argument must be a string type.")
	
	if self:IsDestroying() then
		error(string.format(TOME_IS_DESTROYING_ERROR_MESSAGE, string.format("destroy objects with tag: %s", tag)))
	end
	
	local collectedObjects: {Instance} = self:GetObjectsWithTag(tag)
	for index: number, object: Instance in collectedObjects do
		self:DestroyObject(object)
	end
end

--[[
	
	@within Tome
	@param className string
	@return void
	
	Destroys all the objects contained within the Tome that are of the provided class type.
	
	Will throw an error if the Tome is in the middle of being destroyed.
	
	Example(s):
	```luau
	local Tome = require("../Path/To/Tome")
	local newTome = Tome.new()
	
	-- the apple is a model
	newTome:Add(workspace.Apple)
	
	-- the cube is a part
	newTome:Add(workspace.Cube)
	
	-- will object destroy the cube
	newTome:DestroyObjectsOfType("BasePart")
	```
	
]]
function Tome:DestroyObjectsOfType(typeName: string) : ()
	assert(type(typeName) == "string", "Expected argument #1 to be a string.")
	
	if self:IsDestroying() then
		error(string.format(TOME_IS_DESTROYING_ERROR_MESSAGE, string.format("destroy objects of class: %s", typeName)))
	end
	
	local collectedObjects: {any} = self:GetObjectsOfType(typeName)
	for index: number, object: any in collectedObjects do
		self:DestroyObject(object)
	end
end

--[[
	
	@within Tome
	@param signalName RunServiceSignalName
	@param listener (deltaTime: number) -> () | (time: number, deltaTime: number) -> ()
	@return RBXScriptConnection

	Connects the provided listener to a RunService signal with the provided signal name.

	Will throw an error if the Tome is in the middle of being destroyed.
	
	```luau
	local Tome = require("../Path/To/Tome")
	local newTome = Tome.new()
	
	newTome:HookRunServiceSignal("RenderStepped", function(deltaTime: number)
		print(`[RenderStepped]: Time spent: {deltaTime}`)
	end)

	newTome:HookRunServiceSignal("Stepped", function(timeElapsed: number, deltaTime: number)
		print(`[Stepped]: Time elapsed: {timeElapsed} Time spent: {deltaTime}`)
	end)
	```

]]
function Tome:HookRunServiceSignal(signalName: RunServiceSignalName, listener: (deltaTime: number) -> () | (time: number, deltaTime: number) -> ()) : RBXScriptConnection
	assert(type(listener) == "function", "Bad argument #2 expected a function type but got something else")
	
	local signal: RBXScriptSignal = assert((RunService :: any)[signalName], "Expected a RunService signal but got nil")
	
	return self:Connect(signal, listener)
end

--[[
	
	@within Tome
	@param name string
	@param renderPriority number?
	@param listener (deltaTime: number) -> ()
	@return () -> ()

	Binds to the RunService BindToRenderStep method.

	Arguments are passed sequentially in the same way RunService:BindToRenderStep expects them:
	https://create.roblox.com/docs/reference/engine/classes/RunService#BindToRenderStep

	After hooking, a function is returned which can be called to unbind the render step binding.
	The function is also passed into the Tome to allow the binding to clean up after destruction.

	NOTE: You should not be calling RunService:UnbindRenderStepped as the function will remain
	in memory until the Tome is destroyed.

	Will throw an error if the method is not called from the client.
	Will throw an error if the Tome is in the middle of being destroyed.
	
	Example(s):
	```luau
	local Tome = require("../Path/To/Tome")
	local newTome = Tome.new()
	
	local unbind: () -> () = newTome:BindRenderStepped("STEP", 1, function(deltaTime: number)
		print(`Time spent stepping... {deltaTime}`)
	end)
	
	-- unbinds the render stepped binding after 2 seconds
	task.delay(2, unbind)
	```
	
]]
function Tome:BindRenderStepped(name: string, renderPriority: number?, listener: (deltaTime: number) -> ()) : () -> ()
	assert(type(name) == "string", "Expected argument #1 'name' to be a number type.")
	assert(type(renderPriority) == "number" or renderPriority == nil, "Expected argument #2 'renderPriority' to be a number type or nil.")
	assert(type(listener) == "function", "Expected argument #3 'listener' to be a function type.")
	
	if self:IsDestroying() then
		throwError(string.format(TOME_IS_DESTROYING_ERROR_MESSAGE, "bind to render step"))
	end
	
	RunService:BindToRenderStep(name, renderPriority or 1, listener)
	
	local function unbindRenderStepFunction() : ()
		self.__objects[unbindRenderStepFunction] = nil
		
		RunService:UnbindFromRenderStep(name)
	end
	
	return self:FastAdd(unbindRenderStepFunction, FunctionType)
end

--[[
	
	@within Tome
	@param name string
	@return void
	
	Invokes the RunService:UnbindFromRenderStep method given the provided name as the only argument:
	https://create.roblox.com/docs/reference/engine/classes/RunService#UnbindFromRenderStep
	
	Will throw an error if the method is not called from the client.
	Will throw an error if the Tome is in the middle of being destroyed.
	
	Example(s):
	```luau
	local Tome = require("../Path/To/Tome")
	local newTome = Tome.new()
	
	newTome:BindRenderStepped("Test", 1, function(deltaTime: number)
		print(`Time spent: {deltaTime}`)
	end)
	
	task.wait(2)
	
	newTome:UnbindRenderStepped("Test")
	```
	
]]
function Tome:UnbindRenderStepped(name: string) : ()
	assert(type(name) == "string", "Tome:UnbindRenderStepped name argument must be a string type.")
	
	RunService:UnbindFromRenderStep(name)
end

--[[
	
	@within Tome
	@param duration number
	@param listener (...<vargs>) -> ... any
	@param ... <vargs>
	@return thread
	
	Calls task.delay with the same argument types:
	https://create.roblox.com/docs/reference/engine/libraries/task#delay

	Will automatically add the thread to the Tome and dispose of it properly on destruction.
	
	Will throw an error if the Tome is in the middle of being destroyed.
	
	Example(s):
	```luau
	local Tome = require("../Path/To/Tome")
	local newTome = Tome.new()
	
	someTime:Delay(3, function()
		print("Destroyed the Tome")
	end)
	
	newTome:Destroy()
	```
	
]]
function Tome:Delay<vargs>(duration: number, listener: (...vargs) -> ...any, ...: vargs) : thread
	assert(type(duration) == "number", "Tome:Delay duration argument must be a number type,")
	assert(type(listener) == "function", "Tome:Delay listener argument must be a function type.")
	
	if self:IsDestroying() then
		error(string.format(TOME_IS_DESTROYING_ERROR_MESSAGE, "delay a thread"))
	end
	
	return self:Add(task.delay(duration, listener, ...))
end

--[[
	
	@within Tome
	@param listener (...<vargs>) -> ... any
	@param ... <vargs>
	@return thread
	
	Calls task.spawn with the same argument types:
	https://create.roblox.com/docs/reference/engine/libraries/task#spawn

	Will automatically add the thread to the Tome and dispose of it properly on destruction.
	
	Will throw an error if the Tome is in the middle of being destroyed.
	
	Example(s):
	```luau
	local Tome = require("../Path/To/Tome")
	local newTome = Tome.new()
	
	someTime:Spawn(function()
		while true do
			print("This thread is still running!")
			
			task.wait(1)
		end
	end)
	
	task.wait(5)
	
	-- cancels the thread preventing the loop from continuing
	newTome:Destroy()
	```
	
]]
function Tome:Spawn<vargs>(listener: (...vargs) -> ...any, ...: vargs) : thread
	assert(type(listener) == "function", "Tome:Spawn listener argument must be a function type.")
	
	if self:IsDestroying() then
		error(string.format(TOME_IS_DESTROYING_ERROR_MESSAGE, "spawn a thread"))
	end
	
	return self:Add(task.spawn(listener, ...))
end

--[[
	
	@within Tome
	@param listener (...<vargs>) -> ... any
	@param ... <vargs>
	@return thread
	
	Calls task.defer with the same argument types:
	https://create.roblox.com/docs/reference/engine/libraries/task#defer

	Will automatically add the thread to the Tome and dispose of it properly on destruction.
	
	Will throw an error if the Tome is in the middle of being destroyed.
	
]]
function Tome:Defer<vargs>(listener: (...vargs) -> ...any, ...: vargs) : thread
	assert(type(listener) == "function", "Tome:Defer listener argument must be a function type.")
	
	if self:IsDestroying() then
		error(string.format(TOME_IS_DESTROYING_ERROR_MESSAGE, "defer a thread"))
	end
	
	return self:Add(task.defer(listener, ...))
end

--[[

	@within Tome
	@param thread thread?
	@return void

	Yields the provided thread indefinitely until the Tome is destroyed.
	If no thread is provided, then the current main thread will be used.

	After the Tome has been destroyed, the evaluated thread will resume.

	Example(s):
	```luau
	local Tome = require("../Path/To/Tome")
	local newTome = Tome.new()
	
	print("This prints instantly")

	newTome:DelayDestroy(1)
	newTome:Yield()

	print("This prints after ~1 second")
	```

]]
function Tome:Yield(thread: thread?) : ()
	local currentThread: thread = thread or coroutine.running()
	
	self:FastAdd(currentThread, coroutine.resume)
	
	return coroutine.yield()
end

--[[
	
	@within Tome
	@param object any
	@return boolean
	
	Checks if an object exists within the Tome.
	
	Example(s):
	```luau
	local Tome = require("../Path/To/Tome")
	local newTome = Tome.new()
	
	-- check if the cube exists initially, which it doesn't
	local exists: boolean = newTome:Contains(workspace.Cube)
	print(exists) -- false
	
	-- so we add the cube to the Tome
	newTome:Add(workspace.Cube)
	
	-- and now that the cube has been added, true is returned
	local exists: boolean = newTome:Contains(workspace.Cube)
	print(exists) -- true
	```
	
]]
function Tome:Contains(object: any) : boolean
	return self.__objects[object] ~= nil
end

-- an alias for Tome:Contains (backwards compatability)
Tome.Has = Tome.Contains

--[[
	
	@within Tome
	@return Signal
	
	Constructs a standard Signal and returns it.
	
	Will throw an error if the Tome is in the middle of being destroyed.
	
	Example(s):
	```luau
	local Tome = require("../Path/To/Tome")
	local newTome = Tome.new()
	
	local signal = newTome:Signal()
	
	signal:Connect(function(argument: string)
		print(argument)
	end)
	
	-- fires like any signal
	signal:Fire("Hello, world!")
	
	-- destroy the signal manually (will remain in Tome memory until disposed)
	newTome:Destroy()
	```
	
]]
function Tome:Signal() : Signal.Signal
	if self:IsDestroying() then
		error(string.format(TOME_IS_DESTROYING_ERROR_MESSAGE, "construct a Signal"))
	end
	
	return self:Construct(Signal)
end

--[[

	@within Tome
	@param existing {[any]: any}?
	@return {[any]: any}
	
	Adds the given table to the Tome while using "table.clear" as the destroy method
	This is useful for when you want to clear a table after the Tome is destroyed.

	The use case for this is to clear instance references which will be permanently
	in memory until cleared. Such as round systems that host instances internally.
	
	Will throw an error if the Tome is in the middle of being destroyed.
	
	```luau
	local Tome = require("../Path/To/Tome")
	local newTome = Tome.new()
	
	local myTable: {[any]: any} = newTome:Table({})
	
	print(myTable)
	```
	
]]
function Tome:Table(existing: {[any]: any}?) : {[any]: any}
	if self:IsDestroying() then
		error(string.format(TOME_IS_DESTROYING_ERROR_MESSAGE, "add a table"))
	end
	
	return self:Add(existing or {}, table.clear)
end

--[[
	
	@within Tome
	@param instance Instance
	@param tweenInfo TweenInfo
	@param propertyTable {[string]: any}
	@param metadata {Play: boolean?, RemoveOnComplete: boolean?}?
	@return {[any]: any}
	
	Creates a Tween with the provided arguments. The arguments are sequentially the same as TweenService:Tween:
	https://create.roblox.com/docs/reference/engine/classes/TweenService#Create

	Unlike TweenService's Create method, this one takes in a final optional argument that determines what to
	do with the Tween after it has been stored by the Tome.

	PLay: Will play the tween immediately after creation
	RemoveOnComplete: Will dispose of the tween from the Tome automatically after it has reached a Completed or Cancelled state
	
	Will throw an error if the Tome is in the middle of being destroyed.
	
	```luau
	local Tome = require("../Path/To/Tome")
	local newTome = Tome.new()
	
	local tween: Tween = newTome:Tween(workspce.Cube, TweenInfo.new(1), { Size = Vector3.one * 4 }, { Play = true })

	local function completed() : ()
		print("Finished tween")
	end

	tween.Completed:Once(completed)
	```

]]
function Tome:Tween(
	instance: Instance,
	tweenInfo: TweenInfo,
	propertyTable: {[string]: any},
	metadata: {
		Play: boolean?,
		RemoveOnComplete: boolean?,
	}?
) : Tween
	assert(typeof(instance) == "Instance", "Tome:Tween instance argument must be an Instance type.")
	assert(typeof(tweenInfo) == "TweenInfo", "Tome:Tween tweenInfo argument must be a TweenInfo type.")
	assert(typeof(propertyTable) == "table", "Tome:Tween propertyTable argument must be a table type.")
	assert(type(metadata) == "table" or metadata == nil, "Tome:Tween metadata argument must be a table type, or nil.")
	
	if self:IsDestroying() then
		error(string.format(TOME_IS_DESTROYING_ERROR_MESSAGE, "create a Tween"))
	end
	
	local tween: Tween = self:Add(TweenService:Create(instance, tweenInfo, propertyTable))
	
	if metadata then
		if metadata.RemoveOnComplete then
			local function tweenCompleted(playbackState: Enum.PlaybackState) : ()
				local tweenEnded: boolean = playbackState == Enum.PlaybackState.Completed
					or playbackState == Enum.PlaybackState.Cancelled
				
				if tweenEnded then
					self.__objects[tween] = nil
				end
			end
			
			tween.Completed:Once(tweenCompleted)
		end

		if metadata.Play then
			tween:Play()
		end
	end

	return tween
end

--[[
	
	@within Tome
	@param object any
	@return boolean
	
	Destroys the provided object. The object must be within the Tome to be destroyed.
	If the object is not part of the Tome, then it will be ignored.

	In either case, if the object was destroyed, true will be returned, elsewise false.
	
	Will throw an error if the Tome is in the middle of being destroyed.
	
	Example(s):
	```luau
	local Tome = require("../Path/To/Tome")
	local newTome = Tome.new()
	
	local apple, banana = newTome:AddTuple(workspace.Apple, workspace.Banana)
	
	-- the apple will be destroyed
	newTome:DestroyObject(apple)
	```
	
	```luau
	local Tome = require("../Path/To/Tome")
	local newTome = Tome.new()
	
	local banana = workspace.Banana
	
	-- nothing will happen bceause the banana isn't inside the Tome
	newTome:DestroyObject(banana)
	```
	
]]
function Tome:DestroyObject(object: any) : boolean
	if self:IsDestroying() then
		error(string.format(TOME_IS_DESTROYING_ERROR_MESSAGE, "destroy object"))
	end
	
	local objects: {[any]: DestroyMethod} = self.__objects
	local destroyMethod: DestroyMethod? = objects[object]
	if not destroyMethod then
		return false
	end
	
	objects[object] = nil
	
	if self.__spawnDestroy then
		pcall(task.spawn, destroyObject, object, destroyMethod)
	else
		pcall(destroyObject, object, destroyMethod)
	end
	
	return true
end

--[[
	
	@within Tome
	@param ... any
	@return void
	
	Functions exactly the same as Tome:DestroyObject, with the only difference being that
	tuple objects can be provided instead of singular.
	
	Will throw an error if the Tome is in the middle of being destroyed.
	
	Example(s):
	```luau
	local Tome = require("../Path/To/Tome")
	local newTome = Tome.new()
	
	local apple, banana, pear = newTome:AddTuple(workspace.Apple, workspace.Banana, workspace.Pear)
	
	-- will only destroy the apple and banana
	newTome:DestroyObjects(apple, banana)
	```
	
]]
function Tome:DestroyObjects(...: any) : ()
	if self:IsDestroying() then
		error(string.format(TOME_IS_DESTROYING_ERROR_MESSAGE, "destroy objects"))
	end
	
	for index: number, object: any in {...} do
		self:DestroyObject(object)
	end
end

--[[
	
	@within Tome
	@return boolean
	
	Returns a boolean which determines whether the Tome can be destroyed. Generally, this method
	doesn't need to be called before destroying the Tome, unless there's a deeper reason to do
	so.
	
	```luau
	local Tome = require("../Path/To/Tome")
	local newTome = Tome.new()
	
	-- this function contains a yield that will pause the Tome for 2 seconds
	newTome:Add(function()
		task.wait(2)
	end)
	
	-- delay the code below by 0.5 seconds to let the Tome begin a destroy sequence
	task.delay(0.5, function()
		print(newTome:CanDestroy()) -- false, as the Tome is currently in the middle of being destroyed
	end)

	print(newTome:CanDestroy()) -- true
	
	newTome:Destroy()
	```
	
]]
function Tome:CanDestroy() : boolean
	return not self.__destroying
end

--[[
	
	@within Tome
	@return boolean
	
	Returns whether or not the Tome is currently destroying.

	```luau
	local Tome = require("../Path/To/Tome")
	local newTome = Tome.new()
	
	if newTome:IsDestroying() then
		-- do nothing
	else
		newTome:Add(workspace.Cube)
	end
	```
	
]]
function Tome:IsDestroying() : boolean
	return self.__destroying
end

--[[
	
	@within Tome
	@return {[any]: DestroyMethod}
	
	Returns all the objects contained within the Tome. This should only be used to modify
	the objects and not destroy them directly.
	
	```luau
	local Tome = require("../Path/To/Tome")
	local newTome = Tome.new()
	
	newTome:AddTuple(workspace.Apple, workspace.Banana)
	
	print(newTome:GetObjects()) -> {[Instance(Apple,REF)] = "Destroy", [Instance(Banana,REF)] = "Destroy"}
	```
	
]]
function Tome:GetObjects() : {[any]: DestroyMethod}
	return self.__objects
end

--[[
	
	@within Tome
	@return number
	
	Returns the total amount of objects currectly inside the Tome
	
	```luau
	local Tome = require("../Path/To/Tome")
	local newTome = Tome.new()
	
	newTome:AddTuple(workspace.Apple, workspace.Banana, workspace.Pear)
	
	print(newTome:Count()) --> 3
	```
	
]]
function Tome:Count() : number
	local count: number = 0
	
	local objects: {[any]: DestroyMethod} = self.__objects
	for object: any in objects do
		count += 1
	end
	
	return count
end

--[[
	
	@within Tome
	@param typeName string
	@return {any}

	Returns all the objects that match the provided type.

	NOTE: If a table contains a __type key and the value of that key
	is equal to the type provided. Then the table will be included in the array.
	
	```luau
	local Tome = require("../Path/To/Tome")
	local newTome = Tome.new()
	
	newTome:Add(workspace.Apple)
	newTome:Connect(workspace.ChildAdded, print)
	newTome:Add(function() end)
	
	local objects = newTome:GetObjectsOfType("function")
	print(objects) -> {[1] = function(REF)}
	```
	
	```luau
	local Tome = require("../Path/To/Tome")
	local newTome = Tome.new()
	
	newTome:Add(workspace.Apple)
	newTome:Connect(workspace.ChildAdded, print)
	newTome:Tween(workspace.Cube, TweenInfo.new(5), { Size = Vector3.one })
	newTome:Tween(workspace.AnotherCube, TweenInfo.new(5), { Size = Vector3.one })
	
	local objects = newTome:GetObjectsOfType("Tween")
	print(objects) -> {[1] = Instance(Tween,REF), [2] = Instance(Tween,REF)}
	```
	
]]
function Tome:GetObjectsOfType(typeName: string) : {any}
	assert(type(typeName) == "string", "Tome:GetObjectsOfType className argument must be a string type.")
	
	local objects: {[any]: DestroyMethod} = self.__objects
	local collectedObjects: {any} = {}
	
	for object: any in objects do
		local objectType: string = realTypeOf(object)
		
		if objectType == "Instance" and object:IsA(typeName)
			or objectType == "table" and object.__type == objectType
			or objectType == typeName
		then
			table.insert(collectedObjects, object)
		end
	end
	
	return collectedObjects
end

--[[
	
	@within Tome
	@param tag string
	@return {Instance}
	
	Returns all the objects that have the provided tag. Generally this is only called
	internally, but may prove to be useful in certain cases.
	
	```luau
	local Tome = require("../Path/To/Tome")
	local newTome = Tome.new()
	
	-- set a custom tag (internally will be randomized if not set)
	newTome:SetTag("Demonstration")

	-- add the tag we just created
	local ourTag: string = newTome:GetTag()
	workspace.Cube:AddTag(ourTag)

	print(newTome:GetObjectsWithTag(ourTag)) -> {Instance(Part, REF)}
	```

]]
function Tome:GetObjectsWithTag(tag: string) : {Instance}
	assert(type(tag) == "string", "Tome:GetObjectsWithTag tag argument must be a string type.")
	
	local objects: {[any]: DestroyMethod} = self.__objects
	local collectedObjects: {Instance} = {}
	
	for object: any in objects do
		if typeof(object) == "Instance" and object:HasTag(tag) then
			table.insert(collectedObjects, object)
		end
	end
	
	return collectedObjects
end

--[[
	
	@within Tome
	@param __ignoreDestroyingProperty boolean?
	@return void
	
	Destroys all objects only within the Tome, ignoring objects within pages.

	Will throw an error if the Tome is in the middle of being destroyed, unless
	the ignoreDestroyingProperty argument is set to true.
	
	```luau
	local Tome = require("../Path/To/Tome")
	local newTome = Tome.new()
	
	-- construct a new Page and add an "apple" object to it
	local somePage = newTome:AddPage()
	somePage:Add(workspace.Apple)
	
	-- add a "banana" object to the main Tome
	newTome:Add(workspace.Banana)
	
	-- destroys only the banana as the apple was contained within a Page
	newTome:DestroyAllObjects()
	```
	
]]
function Tome:DestroyAllObjects(__ignoreDestroyingProperty: boolean?) : ()
	if self:IsDestroying() and not __ignoreDestroyingProperty then
		error(string.format(TOME_IS_DESTROYING_ERROR_MESSAGE, "destroy all objects"))
	end
	
	local objects: {[any]: DestroyMethod} = self.__objects
	
	local spawnDestroy: boolean = self.__spawnDestroy
	local warnings: boolean = self.__warnings
	
	if spawnDestroy then
		for object: any, destroyMethod: any in objects do
			local success: boolean, result: any = pcall(task.spawn, destroyObject, object, destroyMethod)
			
			if not success and warnings then
				failedToDestroyObject(object, result)
			end
		end
	else
		for object: any, destroyMethod: any in objects do
			local success: boolean, result: any = pcall(destroyObject, object, destroyMethod)
			
			if not success and warnings then
				failedToDestroyObject(object, result)
			end
		end
	end
	
	table.clear(objects)
end

--[[
	
	@within Tome
	@param __ignoreDestroyingProperty boolean?
	@return void
	
	Destroys all the Pages contained within the Tome. Useful for when needing to destroy all the
	Pages and keep the objects in the primary Tome.
	
	Will throw an error if the Tome is in the middle of being destroyed, unless
	the ignoreDestroyingProperty argument is set to true.
	
	```luau
	local Tome = require("../Path/To/Tome")
	local newTome = Tome.new()

	newTome:Add(workspace.Cube)
	
	local somePage = newTome:AddPage()
	somePage:Add(workspace.Cube2)
	
	newTome:DestroyAllPages()

	print(newTome:GetObjects()) -> {[Instance(Cube, REF)] Destroy}
	print(somePage:GetObjects()) -> {} -- cube 2 no longer remains

	```
]]
function Tome:DestroyAllPages(__ignoreDestroyingProperty: boolean?) : ()
	if self:IsDestroying() and not __ignoreDestroyingProperty then
		error(string.format(TOME_IS_DESTROYING_ERROR_MESSAGE, "destroy all Pages"))
	end
	
	for pageName: string, page: Tome in self.__pages do
		page:Destroy()
	end
end

--[[
	
	@within Tome
	@param duration number
	@return thread
	
	Delays the Tome:Destroy method by a specified duration time. Returns a
	thread which can be cancelled to stop the destroy method from calling.
	This method will yield any thread it was invoked in.
	
	Will throw an error if the Tome is in the middle of being destroyed.
	
	```luau
	local Tome = require("../Path/To/Tome")
	local newTome = Tome.new()
	
	newTome:Add(workspace.Apple)
	
	-- destroys the apple after 2 seconds
	newTome:DelayDestroy(2)
	```
	
	```luau
	local Tome = require("../Path/To/Tome")
	local newTome = Tome.new()
	
	newTome:Add(workspace.Apple)
	
	local tomeDestroyThread: thread = newTome:DelayDestroy(5)
	
	task.wait(2)
	
	-- this prevents the Tome from being destroyed as it suspends the thread
	task.cancel(tomeDestroyThread)
	```
	
]]
function Tome:DelayDestroy(duration: number) : thread
	if self:IsDestroying() then
		error(string.format(TOME_IS_DESTROYING_ERROR_MESSAGE, "delay destroy the Tome"))
	end
	
	return task.delay(duration, self:WrapDestroy())
end

--[[
	
	@within Tome
	@return () -> ()
	
	Wraps the Tome:Destroy method into a function that is then returned. Calling the function
	will destroy the Tome.

	Useful in cases where you need a *cleaner* function within another library or system.
	
	```luau
	local Tome = require("../Path/To/Tome")
	local newTome = Tome.new()
	
	local destroyTome: () -> () = newTome:WrapDestroy()
	
	-- destroys the Tome as though invoking Tome:Destroy
	destroyTome()
	```
	
]]
function Tome:WrapDestroy() : () -> ()
	return function()
		self:Destroy()
	end
end

--[[
	
	@within Tome
	@param callback (...any) -> ()
	@param onDestroyParams OnDestroyParams?
	@return () -> ()
	
	Hooks a callback into the Tome that gets called after `Tome:Destroy` is invoked.
	The callback will always be invoked after all the objects and pages have been destroyed.

	Optional `OnDestroyParams` can be passed in to tell the Tome how to go about calling the
	callback function.

	`Synchronous`: Will call the callback within the same thread, which may result in yielding
	if the callback contains yielding. The default value is `true`

	`RemoveOnDestroy`: Will remove the callback function after the Tome has been destroyed.
	This is usually only used in rarer cases, and the normal way to do this is by passing
	in a function into the Tome instead.

	The returned function can be called to remove the callback from the Tome at any time.

	Will throw an error if the Tome is in the middle of being destroyed.

	```luau
	local Tome = require("../Path/To/Tome")
	local newTome = Tome.new()
	
	newTome:OnDestroy(function()
		print("This Tome has finished destroying itself")
	end)
	
	newTome:Destroy()
	```
	
	```luau
	local Tome = require("../Path/To/Tome")
	local newTome = Tome.new()
	
	local unattachCallback: () -> () = newTome:OnDestroy(function()
		print("This Tome has finished destroying itself")
	end)
	
	-- removes the callback from the Tome
	unattachCallback()
	
	newTome:Destroy()
	```
	
]]
function Tome:OnDestroy(callback: (...any) -> (), onDestroyParams: OnDestroyParams?) : () -> ()
	assert(type(callback) == "function", "Tome:OnDestroy callback argument must be a function type.")
	assert(type(onDestroyParams) == "table", "Expected argument #2 to be a table type. Got something else instead")
	
	if self:IsDestroying() then
		error(string.format(TOME_IS_DESTROYING_ERROR_MESSAGE, "attach a destroy callback"))
	end
	
	local destroyCallbackData: OnDestroyCallbackData = {
		callback = callback,
		OnDestroyParams = onDestroyParams or {
			Synchronous = true,
		},
	}
	
	table.insert(self.__destroyCallbacks, destroyCallbackData)
	
	return function()
		local index: number? = table.find(self.__destroyCallbacks, destroyCallbackData)
		if index then
			table.remove(self.__destroyCallbacks, index)
		end
	end
end

--[[
	
	@within Tome
	@param ... any
	@return void
	
	Destroys the Tome alongside any Pages and objects within it. Clears any references to
	objects and Pages within the Tome too.
	
	Destroy callbacks are invoked after everything is destroyed to guarantee clarity
	Keep in mind synchronous callbacks will yield the Tome if the callback is yieldable
	To prevent callbacks from being synchronous, use:
	```luau
	Tome:OnDestroy(callback, { Synchronous = false })
	```
	
	Will throw an error if the Tome is in the middle of being destroyed.
	
	Example(s):
	```luau
	local Tome = require("../Path/To/Tome")
	local newTome = Tome.new()
	
	-- add a cube to the Tome
	newTome:Add(workspace.Cube)
	
	-- destroys the Tome, which in this case will destroy the cube
	newTome:Destroy()
	```
	
]]
function Tome:Destroy(...: any) : ()
	if self:IsDestroying() then
		error(string.format([[
			%s.
			If Tome:Destroy is invoked frequently, try using Tome:CanDestroy before attempting to destroy the Tome.
		]], string.format(TOME_IS_DESTROYING_ERROR_MESSAGE, "destroy the Tome")))
	end
	
	self.__destroying = true
	
	self:DestroyAllObjects(true)
	self:DestroyAllPages(true)
	
	self.__destroying = false
	
	for index: number, callbackData: OnDestroyCallbackData in self.__destroyCallbacks do
		local callback: (...any) -> () = callbackData.callback
		local onDestroyParams: OnDestroyParams = callbackData.OnDestroyParams
		
		if onDestroyParams.Synchronous then
			callback(...)
		else
			task[onDestroyParams.Deferred and "defer" or "spawn"](callback, ...)
		end
		
		if onDestroyParams.RemoveOnDestroy then
			table.remove(self.__destroyCallbacks, index)
		end
	end
end

return Tome