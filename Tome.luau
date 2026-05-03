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
		const Tome = require("../Path/To/Tome")
		const TomeTypes = require("../Path/To/Types")
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
			const function foo(bar: string) : string
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
	Tome.unschedule : Unschedules an object from the Scheduler.
	Tome.group : Groups tuple objects into a unique array with a metatable attached.
	
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
	Tome:DestroyTuple : Destroys the provided tuple of objects if they exists within the Tome.
	Tome:DestroyObjectsWithTag : Destroys all the objects in the Tome that have the specified tag.
	Tome:DestroyObjectsOfType : Destroys all the objects in the Tome that have the specified type.
	Tome:Contains : Returns whether the specified object exists within the Tome.
	Tome:Has : Alias for Tome:Contains.
	Tome:FromExisting : Creates an Instance with Instance.fromExisting and adds it to the Tome.
	Tome:FastAdd : Adds an object into the Tome but skips over sanity checks and tagging.
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
	Tome:GetName : Returns the name of the Tome.
	Tome:RipPage : Destroys the provided page and removes it from the Tome.
	Tome:RipPages : Destroys and removes all the Pages within a Tome.
	Tome:SetTag : Overrides the default Tome tag used for Instances.
	Tome:Signal : Constructs a standard Signal class and adds it to the Tome.
	Tome:UnbindRenderStepped : Unbinds a binding made with Tome:BindRenderStepped.
	Tome:Tween : Tweens an object and adds the Tween to the Tome.
	Tome:Table : Adds a table inside the Tome and using table.clear as the destroy method
	Tome:OnDestroy : Attaches a callback that listens for when the Tome destroys.
	Tome:Yield() : Yields the current thread and when the Tome is destroyed, it will resume it.
	
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

const Types: boolean = require("./Types")

export type Metaprops = Types.Metaprops
export type TweenMetadata = Types.TweenMetadata
export type DestroyMethod = Types.DestroyMethod
export type RunServiceSignalName = Types.RunServiceSignalName
export type OnDestroyParams = Types.OnDestroyParams
export type OnDestroyCallbackData = Types.OnDestroyCallbackData
export type ObjectDictionary = Types.ObjectDictionary

export type Attachment = Types.Attachment
export type ScheduledObjectEntry = Types.ScheduledObjectEntry

export type RenderStepBinding = {
	name: string,
	owner: Tome,
}

export type CallableRenderStepBinding = typeof(
	setmetatable({} :: RenderStepBinding, {} :: {
		__call: (self: any) -> (),
	})
)

const RunService: RunService = game:GetService("RunService")
const HttpService: HttpService = game:GetService("HttpService")
const TweenService: TweenService = game:GetService("TweenService")
const CollectionService: CollectionService = game:GetService("CollectionService")

const Static = require("./Static")

const TweenType = require("./TweenType")
const GuessType = require("./GuessType")
const ThreadType = require("./ThreadType")
const FunctionType = require("./FunctionType")

-- current hotfix to fix the new type solver crying about string formatting
const TOME_IS_DESTROYING_ERROR_MESSAGE: "Attempted to '%s' while the current Tome is in the middle of being destroyed."
	= "Attempted to '%s' while the current Tome is in the middle of being destroyed."

-- extension method names for classes that may be invoked on when calling Tome:Clone
const EXTENSION_METHOD_NAMES: {string} = { "clone", "Clone", "extend", "Extend" }

const Signal = require("./Signal/Signal")

const throwError = require("./throwError")
const realTypeOf = require("./realTypeOf")
const destroyObject = require("./destroyObject")
const getDestroyMethodForObject = require("./getDestroyMethodForObject")
const failedToDestroyObject = require("./failedToDestroyObject")

const Tome = {}
Tome.__index = Tome
Tome.__type = "Tome"

Tome.TweenType = TweenType
Tome.ThreadType = ThreadType
Tome.FunctionType = FunctionType

Tome.Guess = GuessType

Tome.VERSION = require("./VERSION")

-- TODO: Find a better way to keep method docs while getting better types
export type Tome = typeof(
	setmetatable(
		{} :: InternalTome,
		Tome
	)
)

export type InternalTome = {
	__fastAdd: boolean,
	__spawnDestroy: boolean,
	__warnings: boolean,
	__tagging: boolean,
	
	__pages: {[string]: Tome},
	__objects: {[any]: DestroyMethod},
	
	__destroying: boolean,
	__name: string?,
	__parent: Tome?,
	__tomeTag: string?,
	__useParentMetaprops: boolean,
	__tagRemovedConnection: RBXScriptConnection?,
	__destroyCallbacks: {[number]: OnDestroyCallbackData},
}

const DEFAULT_SPAWN_DESTROY: boolean = Static.SpawnDestroy
const DEFAULT_FAST_ADD: boolean = Static.FastAdd
const DEFAULT_WARNINGS: boolean = Static.Warnings
const DEFAULT_TAGGING: boolean = Static.Tagging
const DEFAULT_USE_PARENT_METAPROPS: boolean = Static.UseParentMetaprops

--[[
	
	@constructor Tome.new()
	@param metaprops Metaprops
	@return Tome
	
	Constructs and returns a new Tome object.
	
	Example(s):
	```luau
	const Tome = require("../Path/To/Tome")
	const newTome = Tome.new()
	
	-- add a cube to the new Tome
	newTome:Add(workspace.Cube)
	
	-- destroys the Tome as well as the cube
	newTome:Destroy()
	```
	
]]
function Tome.new(metaprops: Types.Metaprops?) : Tome
	const FAST_ADD: boolean? = metaprops and metaprops.FastAdd
	const TAGGING: boolean? = metaprops and metaprops.Tagging
	const WARNINGS: boolean? = metaprops and metaprops.Warnings
	const SPAWN_DESTROY: boolean? = metaprops and metaprops.SpawnDestroy
	const USE_PARENT_METAPROPS: boolean? = metaprops and metaprops.UseParentMetaprops
	
	-- creating the variables to stop the new solver from crying.
	-- will be removed once the solver is refined.
	const tagRemovedConnection: RBXScriptConnection?,
	parent: Tome?,
	name: string? = nil, nil, nil
	
	return setmetatable({
		__fastAdd = if type(FAST_ADD) == "boolean" then FAST_ADD else DEFAULT_FAST_ADD,
		__spawnDestroy = if type(SPAWN_DESTROY) == "boolean" then SPAWN_DESTROY else DEFAULT_SPAWN_DESTROY,
		__warnings = if type(WARNINGS) == "boolean" then WARNINGS else DEFAULT_WARNINGS,
		__tagging = if type(TAGGING) == "boolean" then TAGGING else DEFAULT_TAGGING,
		__pages = {},
		__objects = {},
		__destroying = false,
		__name = name,
		__parent = parent,
		__useParentMetaprops = if type(USE_PARENT_METAPROPS) == "boolean" then USE_PARENT_METAPROPS else DEFAULT_USE_PARENT_METAPROPS,
		__tomeTag = (TAGGING and HttpService:GenerateGUID(false)) or nil,
		__tagRemovedConnection = tagRemovedConnection,
		__destroyCallbacks = {},
	}, Tome)
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
	const Tome = require("../Path/To/Tome")
	const newTome = Tome.new()
	
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
	const usesTomeMethods: boolean = type(object.Destroy) == "function"
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
const function bubbleUpSchedule(
	index: number,
	hash: {ScheduledObjectEntry},
	indexMap: {[any]: number}
) : ()
	while index > 1 do
		const parentIndex: number = math.floor(index * 0.5)
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
const function bubbleDownSchedule(
	index: number,
	hash: {ScheduledObjectEntry},
	indexMap: {[any]: number}
) : ()
	const hashSize: number = #hash
	
	while true do
		local smallestIndex: number = index
		
		const leftIndex: number = index * 2
		const rightIndex: number = leftIndex + 1
		
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
const function popRootScheduledObject(
	heap: {ScheduledObjectEntry},
	indexMap: {[any]: number}
) : ScheduledObjectEntry
	const heapSize: number = #heap
	const rootEntry: ScheduledObjectEntry = heap[1]
	
	heap[1] = heap[heapSize]
	heap[heapSize] = nil
	
	indexMap[rootEntry.Object] = nil
	
	if heapSize > 1 then
		indexMap[heap[1].Object] = 1
		
		bubbleDownSchedule(1, heap, indexMap)
	end
	
	return rootEntry
end

const Scheduler = {}
Scheduler.DefaultSchedulerSignalName = "Heartbeat" :: RunServiceSignalName
Scheduler.__stepConnection = nil :: RBXScriptConnection?

-- no point in storing these in the Scheduler because they shouldn't be changed anyway
const scheduledObjectEntries: {ScheduledObjectEntry} = {}
const objectToIndexMap: {[any]: number} = {}

--[[
	
	@return void
	
	Checks the object entries hash and pops an entry if its expiration time is less (or equal) to the current time
	If no object entries exist, the Scheduler will stop itself from running to save resources.
	
]]
function Scheduler.stepScheduler()
	const currentTime: number = os.clock()
	
	if Scheduler.isScheduleEmpty() then
		Scheduler.stopScheduler()
		return
	end
	
	while
		scheduledObjectEntries[1] and scheduledObjectEntries[1].ExpiresAt <= currentTime
	do
		const poppedEntry: ScheduledObjectEntry = popRootScheduledObject(scheduledObjectEntries, objectToIndexMap)
		
		destroyObject(poppedEntry.Object, poppedEntry.DestroyMethod)
	end
end

--[[
	
	@return boolean
	
	Returns whether the Scheduler is currently running
	
]]
function Scheduler.isSchedulerRunning() : boolean
	return Scheduler.__stepConnection and Scheduler.__stepConnection.Connected or false
end

--[[
	
	@return boolean
	
	Returns whether the Scheduler is empty (whether the object entries hash is empty)
	
]]
function Scheduler.isScheduleEmpty() : boolean
	return #scheduledObjectEntries == 0
end

const function newSpawner() : ()
	while true do
		const callback: () -> () = coroutine.yield()
		
		callback()
	end
end

const spawner: thread = coroutine.create(newSpawner)
coroutine.resume(spawner)

--[[
	
	@param runServiceSignalName RunServiceSignalName?
	@return void
	
	Connections a RunService signal to the `Scheduler.stepScheduler` function.
	Optionally you can start the Scheduler with a given signal name or:
	You can set the Scheduler.DefaultSchedulerSignalName to any RunService signal name.
	
]]
function Scheduler.startScheduler(runServiceSignalName: RunServiceSignalName?) : ()
	Scheduler.stopScheduler()
	
	coroutine.resume(spawner, function()
		Scheduler.__stepConnection = (RunService :: any)
		[runServiceSignalName or Scheduler.DefaultSchedulerSignalName]:Connect(Scheduler.stepScheduler)
	end)
end

--[[
	
	@return void
	
	Disconnects the Scheduler stopping it completely
	
]]
function Scheduler.stopScheduler() : ()
	if Scheduler.__stepConnection and Scheduler.__stepConnection.Connected then
		Scheduler.__stepConnection:Disconnect()
	end
end

Tome.Scheduler = Scheduler

--[[
	
	@param self Group<any>
	@return void
	
	Destroys a group by iterating through it, finding destroy methods
	for every object and then destroying those same objects.
	
	Used internally by Tome to clean up scheduled groups.
	
]]
const function destroyGroup(self: any) : ()
	for index: number = 1, #self do
		const object: any = self[index]
		
		destroyObject(object, getDestroyMethodForObject(object))
	end
end

type GroupMetamethods = {
	__call: (self: any) -> (),
}

const GROUP_METAMETHODS: GroupMetamethods = {
	__call = destroyGroup,
}

export type Group<Tuple> = typeof(
	setmetatable({} :: {Tuple}, GROUP_METAMETHODS)
)

--[[
	
	@within Tome
	@param object any
	@param lifeTime number
	@return void
	
	Schedules an object to be deleted after the given life time. Works similarly to
	`Debris:AddItem`. Any scheduled objects will also remain in the heap even if the main thread dies
	
	Example(s):
	```luau
	const Tome = require("../Path/To/Tome")
	
	Tome.schedule(workspace.Part, 2.0) -- schedules the part to be destroyed after 2 seconds
	```
	
	```luau
	const Tome = require("../Path/To/Tome")
	
	const part = Tome.schedule(workspace.Part2, 3) -- Scheduler uses generics to return the object afterwards for some useful cases
	
	Tome.schedule(function() -- you can insert any objects that go inside Tome as well, not just `Instance`s i.e. functions, threads, classes.
		print("hello")
	end, 2)
	
	script:Destroy() -- both the scheduled objects above will will get cleared up, even after the main thread dies
	```
	
]]
function Tome.schedule<object>(object: object, lifeTime: number, destroyMethod: DestroyMethod?) : object
	assert(type(lifeTime) == "number", "Expected argument #2 lifeTime to be a number type")
	
	if lifeTime <= 0 then
		destroyObject(object, destroyMethod or getDestroyMethodForObject(object))
		
		return object
	end
	
	if not Scheduler.isSchedulerRunning() then
		Scheduler.startScheduler()
	end
	
	const currentTime: number = os.clock()
	const expirationTime: number = currentTime + lifeTime
	
	const existingObjectIndex: number = objectToIndexMap[object]
	if existingObjectIndex then
		const scheduledObjectEntry: ScheduledObjectEntry = scheduledObjectEntries[existingObjectIndex]
		
		scheduledObjectEntry.ExpiresAt = expirationTime
		
		if destroyMethod then
			scheduledObjectEntry.DestroyMethod = destroyMethod
		end
		
		bubbleUpSchedule(existingObjectIndex, scheduledObjectEntries, objectToIndexMap)
		bubbleDownSchedule(existingObjectIndex, scheduledObjectEntries, objectToIndexMap)
		
		return object
	end
	
	const scheduledEntry: ScheduledObjectEntry = {
		Object = object,
		DestroyMethod = destroyMethod or getDestroyMethodForObject(object),
		ExpiresAt = expirationTime,
	}
	
	const insertionIndex: number = #scheduledObjectEntries + 1
	
	table.insert(scheduledObjectEntries, insertionIndex, scheduledEntry)
	
	objectToIndexMap[object] = insertionIndex
	
	bubbleUpSchedule(insertionIndex, scheduledObjectEntries, objectToIndexMap)
	
	return object
end

--[[
	
	@param ... T
	@return {...T}
	
	Groups tuple objects into a table with an internal metatable attached.
	The metatable is complementary to `Tome.schedule` to allow for multiple
	objects to be scheduled under a single entry, rather than multiple.
	
	Example(s):
	```luau
	const Tome = require("../Path/To/Tome")
	
	const group: {Part} = Tome.group(workspace.Part, workspace.Part2)
	
	Tome.schedule(group, 2.0)
	```
	
]]
function Tome.group<Tuple>(...: Tuple) : Group<Tuple>
	return setmetatable({
		...
	}, GROUP_METAMETHODS)
end

--[[
	
	@param object<object>
	@return <object>
	
	Unschedules the provided object if it exists within the Scheduler.
	Removing the object doesn't clean up the object.
	
	```luau
	const Tome = require("../Path/To/Tome")
	
	const part: Part = workspace.Part
	
	Tome.schedule(part, 3.0) --> schedules to destroy the part after 3 seconds
	
	task.wait(1)
	
	Tome.unschedule(part) -- change our mind about destroying it, removing it from the Scheduler
	```
	
]]
function Tome.unschedule<object>(object: object) : object
	const existingObjectIndex: number? = objectToIndexMap[object]
	if not existingObjectIndex then
		return object
	end
	
	const hashSize: number = #scheduledObjectEntries
	
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
function Tome.SetTag(self: Tome, tag: string?) : Tome
	assert(type(tag) == "string", "Expected argument #1 'tag' to be a string type, or nil.")
	
	const oldTag: string? = self:GetTag()
	if oldTag then
		for index: number, instance: Instance in CollectionService:GetTagged(oldTag) do
			instance:RemoveTag(oldTag)
			instance:AddTag(tag)
		end
	end
	
	if not tag then
		self:__disconnectTagRemovedConnection()
		
		return self
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
function Tome.GetTag(self: Tome) : string?
	return self.__tomeTag
end

--[[
	
	@within Tome
	@return void
	
	An internal method used to bind the "tag removed" connection. This method
	shouldn't be called outside this prototype.
	
]]
function Tome.__connectTagRemoved(self: Tome) : ()
	const tagRemovedConnection: RBXScriptConnection? = self.__tagRemovedConnection
	if tagRemovedConnection and tagRemovedConnection.Connected then
		return
	end
	
	const tag: string? = self:GetTag()
	if not tag then
		return
	end
	
	const function instanceRemoved(instance: Instance) : ()
		self.__objects[instance] = nil
		
		const objectExists: {Instance} = CollectionService:GetTagged(tag)
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
function Tome.__disconnectTagRemovedConnection(self: Tome) : ()
	const tagRemovedConnection: RBXScriptConnection? = self.__tagRemovedConnection
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
function Tome.Rename(self: Tome, name: string?) : Tome
	assert(type(name) == "string" or name == nil, "Expected argument #1 'name' to be a string type, or nil.")
	
	self.__name = name
	
	return self
end

--[[
	
	@within Tome
	@return string?
	
	Returns the name of the Tome. If the Tome doesn't have a name, nil will be returned.
	
	Example(s):
	```luau
	const Tome = require("../Path/To/Tome")
	
	const newTome = Tome.new()
	newTome:Rename("Test")
	
	print(newTome:GetName()) --> "Test"
	```
	
]]
function Tome.GetName(self: Tome) : string?
	return self.__name
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
	const Tome = require("../Path/To/Tome")
	const newTome = Tome.new()
	
	-- construct a new Page for the Tome
	const somePage = newTome:AddPage()
	
	-- add an apple to the Page
	somePage:Add(workspace.Apple)
	
	-- add a banana to the Tome
	newTome:Add(workspace.Banana)
	
	-- destroys both the apple, and banana as the Page also gets destroyed
	newTome:Destroy()
	```
	
	```luau
	const Tome = require("../Path/To/Tome")
	const newTome = Tome.new()
	
	-- construct a new Page for the Tome with a provided name
	newTome:AddPage("SomeName")
	
	-- get the Page by name
	const somePage = newTome:GetPage("SomeName")
	```
	
]]
function Tome.AddPage(self: Tome, name: string?, metaprops: Types.Metaprops?) : Tome
	assert(type(name) == "string" or name == nil, "Expected argument #1 'name' to be a string type, or nil.")
	
	if self:IsDestroying() then
		error(string.format(TOME_IS_DESTROYING_ERROR_MESSAGE, "add a Page to the Tome"))
	end
	
	const keyNameToUse: string = name or HttpService:GenerateGUID(false)
	
	const page: Tome? = self.__pages[keyNameToUse]
	if page then
		throwError("Attempted to add a Page that already exists with the given name.")
	end
	
	local newMetaprops: Metaprops = {}
	if not metaprops and self.__useParentMetaprops then
		const FAST_ADD: boolean = self.__fastAdd
		const SPAWN_DESTROY: boolean = self.__spawnDestroy
		const WARNINGS: boolean = self.__warnings
		const TAGGING: boolean = self.__tagging
		const USE_PARENT_METAPROPS: boolean = self.__useParentMetaprops
		
		const constructedMetaprops: Metaprops = {
			FastAdd = FAST_ADD,
			SpawnDestroy = SPAWN_DESTROY,
			Warnings = WARNINGS,
			Tagging = TAGGING,
			UseParentMetaprops = USE_PARENT_METAPROPS,
		}
		
		newMetaprops = constructedMetaprops
	end
	
	const newPage: Tome = Tome.new(newMetaprops)
	newPage:Rename(name)
	newPage.__parent = self
	
	self.__pages[keyNameToUse] = newPage
	
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
function Tome.__findPage(self: Tome, pageToFind: Tome) : (Tome?, Tome?)
	-- TODO: Fix type issues once the new solver gets released
	const subPages: {any} = {}
	
	for name: string, page: any in self.__pages do
		if page == pageToFind then
			return page, self
		end
		
		table.insert(subPages, page)
	end
	
	for index: number, page: Tome in subPages do
		const pageFound: Tome? = page:__findPage(pageToFind)
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
	const Tome = require("../Path/To/Tome")
	const newTome = Tome.new()
	
	const somePage = newTome:AddPage()
	
	print(newTome:GetParent()) -> ()
	print(somePage:GetParent()) -> newTome
	```
	
]]
function Tome.GetParent(self: Tome) : Tome?
	return self.__parent
end

--[[
	
	@within Tome
	@return Tome?
	
	Returns the highest ancestor of a chain of Tomes
	
	This is an internal method that shouldn't be used outside this prototype.
	
]]
function Tome.__getLastParent(self: Tome) : Tome?
	local latestParent: Tome? = self.__parent
	
	while latestParent do
		const parent: Tome? = latestParent.__parent
		if not parent then
			return latestParent
		end
		
		latestParent = parent
	end
	
	return latestParent
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
	const Tome = require("../Path/To/Tome")
	
	const newTome = Tome.new()
	
	const somePage = newTome:AddPage("Demonstration")
	
	print(newTome:GetPage("Demonstration")) -> Page(somePage)
	
	newTome:RipPage(somePage)
	
	print(newTome:GetPage("Demonstration")) -> nil -- the page has been completely erased
	```
	
]]
function Tome.RipPage(self: Tome, nameOrPage: string | Tome) : Tome
	if self:IsDestroying() then
		error(string.format(TOME_IS_DESTROYING_ERROR_MESSAGE, "rip Page from the Tome"))
	end
	
	const nameOrPageType: string = realTypeOf(nameOrPage)
	if nameOrPageType == "Tome" then
		const page: Tome?, parentPage: Tome? = self:__findPage(nameOrPage :: Tome)
		if not page or not parentPage then
			return throwError("Attempted to rip a Page that doesn't exist. Profiled using recursion")
		end
		
		page:Destroy()
		
		const pageName: string? = page.__name
		if pageName then
			parentPage.__pages[pageName] = nil
		end
		
		return self
	elseif nameOrPageType == "string" then
		const page: Tome? = self.__pages[nameOrPage :: string]
		if not page then
			return throwError("Attempted to rip a Page that doesn't exist. Profiled using a string")
		end
		
		self.__pages[nameOrPage :: string] = nil
		
		page:Destroy()
		
		return self
	end
	
	return throwError("Expected argument #1 'nameOrPage' to be a string or Tome type.", "Only a string (name) or Page (Tome) can be passed in")
end

--[[
	
	@within Tome
	@return void
	
	Rips all the Pages contained within the Tome. Useful when needing
	to dispose of Pages that don't need to occupy the Tome anymore.

	Example(s):
	```luau
	const Tome = require("../Path/To/Tome")

	const newTome = Tome.new()
	
	const somePage = newTome:AddPage("Demonstration")

	newTome:RipPages()

	print(newTome:GetPage("Demonstration")) -> nil -- the page has been completely erased
	```
	
]]
function Tome.RipPages(self: Tome) : ()
	self:DestroyAllPages()
	
	table.clear(self.__pages)
end

--[[
	
	@within Tome
	@param name string
	@return Tome?
	
	Attempts to return a Page from a given name. Typically useful when a Tome is shared
	among other scripts, and in some cases fetching a specific Page may be necessary.
	
	Example(s):
	```luau
	const Tome = require("../Path/To/Tome")

	const newTome = Tome.new()
	
	-- we need to access 'somePage' which is contained within another scope
	do
		const somePage = newTome:AddPage("Demonstration")
	end
	
	const somePage = newTome:GetPage("Demonstration")
	print(somePage) -> Page(somePage)
	```

]]
function Tome.GetPage(self: Tome, name: string) : Tome?
	assert(type(name) == "string", "Expected argument #1 'name' to be a string type.")
	
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
	const Tome = require("../Path/To/Tome")

	const newTome = Tome.new()
	const someOtherTome = Tome.new()

	-- initially create a Page within newTome
	const somePage = newTome:AddPage("Demonstration")

	print(newTome:GetPage("Demonstration")) -> Page(somePage)
	print(someOtherTome:GetPage("Demonstration")) -> nil

	-- at some point you may want to move the Page to another Tome or Page:
	somePage:Parent(someOtherTome)

	print(newTome:GetPage("Demonstration")) -> nil
	print(someOtherTome:GetPage("Demonstration")) -> Page(somePage)
	```

]]
function Tome.Parent(self: Tome, newTome: Tome?) : Tome
	const isTome: boolean = realTypeOf(newTome) == "Tome"
	assert(isTome or newTome == nil, "Expected argument #1 'newTome' to be a Tome type, or nil.")
	
	if self:IsDestroying() then
		error(string.format(TOME_IS_DESTROYING_ERROR_MESSAGE, "parent a Tome"))
	end
	
	if newTome and newTome:IsDestroying() then
		throwError("Cannot add the current Tome to the newTome because the new Tome is in the middle of being destroyed.", "Ensure the new Tome is not destroying with Tome:IsDestroying.")
	end
	
	const name: string? = self.__name
	if not name then
		return self
	end
	
	const parent: Tome? = self.__parent
	if parent then
		self.__parent = nil
		
		parent.__pages[name] = nil
	end
	
	if newTome then
		newTome.__pages[name] = self
		
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
	const Tome = require("../Path/To/Tome")

	const newTome = Tome.new()
	const someOtherTome = Tome.new()

	const somePage = newTome:AddPage("Demonstration")

	newTome:GivePage("Demonstration", someOtherTome)
	```

]]
function Tome.GivePage(self: Tome, pageName: string, newTome: Tome) : ()
	assert(type(pageName) == "string", "Expected argument #1 to be a string type.")
	assert(realTypeOf(newTome) == "Tome", "Expected argument #2 to be a Tome type.")
	
	const page: Tome? = self:GetPage(pageName)
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
	const Tome = require("../Path/To/Tome")
	const newTome = Tome.new()
	const someOtherTome = Tome.new()
	
	const apple = workspace.Apple
	newTome:Add(apple)
	
	print(newTome:Contains(apple)) -- true
	
	-- move the apple to the other Tome
	newTome:Move(apple, someOtherTome)
	
	print(newTome:Contains(apple)) -- false
	print(someOtherTome:Contains(apple)) -- true
	```
	
]]
function Tome.Move<object>(self: Tome, object: object, otherTome: Tome) : object
	assert(realTypeOf(otherTome) == "Tome", "Expected argument #2 'otherTome' to be a Tome type.")
	
	if self:IsDestroying() then
		error(string.format(TOME_IS_DESTROYING_ERROR_MESSAGE, "move object to another Tome"))
	end
	
	const destroyMethod: DestroyMethod? = self.__objects[object]
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
	
]]
const function validateObject(object: any, tome: Tome) : ()
	const objectType: string = realTypeOf(object)
	const objectIsTome: boolean = objectType == "Tome"
	if objectIsTome then
		if object == tome then
			throwError("Attempted to add current Tome (self) to the current Tome (self) Upon calling :Destroy, indefinite recursion will occur", "Ensure that the Tome isn't added into itself.")
		end
		
		const lastParent: Tome? = tome:__getLastParent()
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
		const tomeTag: string? = tome:GetTag()
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
	const Tome = require("../Path/To/Tome")
	const newTome = Tome.new()
	
	const cube = newTome:Add(workspace.Cube)
	
	-- will destroy the cube
	newTome:Destroy()
	```
	
	```luau
	const Tome = require("../Path/To/Tome")
	const newTome = Tome.new()
	
	-- Giving in a custom destroy method, in this case "Destroy"
	-- which will be called on the cube as a function
	const cube = newTome:Add(workspace.Cube, "Destroy")
	
	-- will destroy the cube
	newTome:Destroy()
	```
	
	```luau
	const Tome = require("../Path/To/Tome")
	const newTome = Tome.new()
	
	-- Giving in another custom method, in this case a function.
	-- This function will be called when the Tome is destroyed,
	-- giving in the object as the first argument to allow you to destroy the object however you like
	const cube = newTome:Add(workspace.Cube, function(cube: BasePart)
		cube:Destroy()
	end)
	
	-- will destroy the cube
	newTome:Destroy()
	```
	
]]
function Tome.Add<object>(self: Tome, object: object, destroyMethod: Types.DestroyMethod?) : object
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
	
	Will throw an error if the Tome is in the middle of being destroyed.
	
	Example(s):
	```luau
	const newTome: Tome.Tome = Tome.new()
	
	newTome:AddFromDictionary({
		[workspace.Part] = Tome.Guess,
		[workspace.Part2] = "Destroy",
	})
	
	newTome:DelayDestroy(2.0)
	```
	
]]
function Tome.AddFromDictionary(self: Tome, dictionary: ObjectDictionary) : ObjectDictionary
	if self:IsDestroying() then
		error(string.format(TOME_IS_DESTROYING_ERROR_MESSAGE, "add dictionary of objects"))
	end
	
	assert(type(dictionary) == "table", "Expected argument #1 'dictionary' to be a table type.")
	
	const FAST_ADD: boolean = self.__fastAdd
	
	if FAST_ADD then
		for object: any, destroyMethod: DestroyMethod in dictionary do
			validateObject(object, self)
			
			self.__objects[object] = destroyMethod == GuessType
				and getDestroyMethodForObject(object) or destroyMethod
		end
	else
		for object: any, destroyMethod: DestroyMethod in dictionary do
			self.__objects[object] = destroyMethod == GuessType
				and getDestroyMethodForObject(object) or destroyMethod
		end
	end
	
	return dictionary
end

const MIDDLEWARE_WARNING_TEMPLATE: string = "\n\nCaught error during middleware function: %*"

--[[
	
	@within Tome
	@param object any
	@param middleware (object: any) -> ()
	@param destroyMethod DestroyMethod?
	@param synchronous boolean?
	@return object any
	
	Adds an object into the Tome with a middleware function. This function
	gets called when the Tome gets destroyed, but prior to the object being
	destroyed. This allows for short effects prior to destruction. e.g. Fading out,
	Explosions, Scaling, etc.
	
	The middleware by default does **not** run inside the same thread when Tome
	destroys objects. This allows for yielding inside middleware without worrying
	about blocking the main thread. Optionally you can disable this with the 4th
	argument.
	
	For optimization, you can also provide a custom destroy method as the 3rd
	argument.
	
	Middleware are run in a safe call, so errors don't prevent clean up. To get access
	to these errors, enable the 'Warnings' metaprop during instantiation of the Tome.
	
	Will throw an error if the Tome is in the middle of being destroyed.
	
	Example(s):
	```luau
	const Tome = require("../Path/To/Tome")
	const newTome = Tome.new()
	
	newTome:AddWithMiddleware(workspace.Part, function(object: Part)
		for transparency: number = 0, 1, 0.1 do
			object.Transparency = transparency
			
			task.wait(0.05)
		end
	end)
	```
	
	```luau
	const Tome = require("../Path/To/Tome")
	const newTome = Tome.new()
	
	newTome:AddWithMiddleware(
		workspace.Part,
		function(object: Part)
			task.wait(2)
		end,
		"Destroy", -- custom destroy method
		true -- synchronous (will run in the same thread when destroying)
	)
	```
	
]]
function Tome.AddWithMiddleware<object>(
	self: Tome,
	object: object,
	middleware: (object: object) -> (),
	destroyMethod: Types.DestroyMethod?,
	synchronous: boolean?
) : object
	if self:IsDestroying() then
		error(string.format(TOME_IS_DESTROYING_ERROR_MESSAGE, "add with middleware to the Tome"))
	end
	
	const function destroyWithMiddleware(object: object) : ()
		const success: boolean, result: unknown = pcall(middleware, object)
		if not success and self.__warnings then
			warn(string.format(MIDDLEWARE_WARNING_TEMPLATE, result))
		end
		
		destroyObject(object, destroyMethod or getDestroyMethodForObject(object))
	end
	
	self.__objects[object] = synchronous and destroyWithMiddleware or function(object: object)
		task.spawn(destroyWithMiddleware, object)
	end
	
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
function Tome.FastAdd<object>(self: Tome, object: object, destroyMethod: Types.DestroyMethod?) : object
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
	const Tome = require("../Path/To/Tome")
	const newTome = Tome.new()
	
	-- adds the apple, banana and pear to the Tome
	const apple, banana, pear = newTome:AddTuple(workspace.Apple, workspace.Banana, workspace.Pear)
	
	-- will destroy the apple, banana and pear
	newTome:Destroy()
	```
	
]]
function Tome.AddTuple<object...>(self: Tome, ...) : object...
	if self:IsDestroying() then
		error(string.format(TOME_IS_DESTROYING_ERROR_MESSAGE, "add tuple objects to the Tome"))
	end
	
	const FAST_ADD: boolean = self.__fastAdd
	
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
	const Tome = require("../Path/To/Tome")
	const newTome = Tome.new()
	
	const objectsToAdd = {workspace.Apple, workspace.Banana, workspace.Pear}
	
	-- adds the apple, banana and pear to the Tome
	const returnedObjects = newTome:AddFromArray(fruits)
	
	-- will destroy the apple, banana and pear
	newTome:Destroy()
	```
	
]]
function Tome.AddFromArray<objectsArray>(self: Tome, objectsArray: objectsArray) : objectsArray
	assert(type(objectsArray) == "table", "Expected argument #1 'objectsArray' to be a table type.")
	
	if self:IsDestroying() then
		error(string.format(TOME_IS_DESTROYING_ERROR_MESSAGE, "add objects from array"))
	end
	
	const FAST_ADD: boolean = self.__fastAdd
	
	if FAST_ADD then
		for index: number, object: any in objectsArray :: any do
			validateObject(object, self)
			
			self.__objects[object] = getDestroyMethodForObject(object)
		end
	else
		for index: number, object: any in objectsArray :: any do
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
function Tome.AddPromise(self: Tome, promise: Types.Promise) : Types.Promise -- any should be considered a Promise, for better auto complete make sure to type cast (promise :: Promise)
	assert(promise
		and type(promise) == "table"
		and type(promise.getStatus) == "function"
		and type(promise.finally) == "function"
		and type(promise.cancel) == "function"
		,[[
			Expected argument #1 'promise' to be a Promise type.
		]]
	)
	
	if self:IsDestroying() then
		error(string.format(TOME_IS_DESTROYING_ERROR_MESSAGE, "add Promise"))
	end
	
	const typedPromise: Types.Promise = promise
	
	const status: string = string.lower(typedPromise:getStatus())
	if status == "started" then
		typedPromise:finally(function()
			self.__objects[typedPromise] = nil
		end)
		
		self.__objects[typedPromise] = "cancel"
		
		return typedPromise
	end
	
	return throwError("The provided Promise has already finished executing.", "Ensure the provided Promise is still active.")
end

--[[
	
	@within Tome
	@param object<any>
	@return object<any>
	
	Removes the object from the Tome (doesn't dispose of the object) it can be
	added at a later time if needed.
	
	Objects that need to be disposed of should be passed through `Tome:DestroyObject`
	or `Tome:DestroyTuple` for series of objects.
	
	Will throw an error if the Tome is in the middle of being destroyed.
	
	Example(s):
	```luau
	const Tome = require("../Path/To/Tome")
	const newTome = Tome.new()
	
	const cube = newTome:Add(workspace.Cube)
	
	-- remove the cube from the Tome
	newTome:Remove(cube)
	
	-- will not destroy the cube as it was removed before the Tome was destroyed.
	newTome:Destroy()
	```
	
]]
function Tome.Remove<object>(self: Tome, object: object) : object
	if self:IsDestroying() then
		error(string.format(TOME_IS_DESTROYING_ERROR_MESSAGE, "remove an object"))
	end
	
	if typeof(object) == "Instance" then
		const tomeTag: string? = self:GetTag()
		if tomeTag then
			(object :: Instance):RemoveTag(tomeTag)
		end
	end
	
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
	const Tome = require("../Path/To/Tome")
	const newTome = Tome.new()
	
	const apple, banana, pear = newTome:AddTuple(workspace.Apple, workspace.Banana, workspace.Pear)
	
	-- don't include the pear
	newTome:RemoveTuple(apple, banana)
	
	-- will only destroy the pear, as the apple and the banana were removed from the Tome
	newTome:Destroy()
	```
	
]]
function Tome.RemoveTuple<object...>(self: Tome, ...) : object...
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
	const Tome = require("../Path/To/Tome")
	const newTome = Tome.new()
	
	const objects = {workspace.Apple, workspace.Banana, workspace.Pear}
	
	-- adds the apple, banana and pear
	newTome:AddFromArray(objects)
	
	-- removes the apple, banana and pear
	newTome:RemoveFromArray(objects)
	
	-- destroys the Tome, and no objects get destroyed
	newTome:Destroy()
	```
	
]]
function Tome.RemoveFromArray<objectsArray>(self: Tome, objectsArray: objectsArray) : objectsArray
	assert(type(objectsArray) == "table", "Expected argument #1 'objectsArray' to be a table type.")
	
	if self:IsDestroying() then
		error(string.format(TOME_IS_DESTROYING_ERROR_MESSAGE, "remove objects from array"))
	end
	
	for index: number, object: any in objectsArray :: any do
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
	const Tome = require("../Path/To/Tome")
	const newTome = Tome.new()
	
	-- add a tag to the cube
	const cube = workspace.Cube
	cube:AddTag("SomeTag")
	
	-- add the cube to the Tome
	newTome:Add(cube)
	
	-- will remove the cube as it contains the "SomeTag" tag
	newTome:RemoveObjectsWithTag("SomeTag")
	```
	
]]
function Tome.RemoveObjectsWithTag(self: Tome, tag: string) : ()
	assert(type(tag) == "string", "Expected argument #1 'tag' to be a string type.")
	
	if self:IsDestroying() then
		error(string.format(TOME_IS_DESTROYING_ERROR_MESSAGE, "remove objects with tag"))
	end
	
	const objectsWithTag: {any} = self:GetObjectsWithTag(tag)
	
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
	const Tome = require("../Path/To/Tome")
	const newTome = Tome.new()
	
	const cube = workspace.Cube -- "Part"
	const someModel = workspace.SomeModel -- "Model"
	
	-- add the objects to the Tome
	newTome:AddTuple(cube, someModel)
	
	-- remove the objects that are a "Model"
	newTome:RemoveObjectsOfType("Model")
	
	-- destroys only the cube as the "someModel" object was removed prior because it was a model
	newTome:Destroy()
	```
	
]]
function Tome.RemoveObjectsOfType(self: Tome, typeName: string) : ()
	assert(type(typeName) == "string", "Expected argument #1 to be a string type.")
	
	if self:IsDestroying() then
		error(string.format(TOME_IS_DESTROYING_ERROR_MESSAGE, "remove objects of class"))
	end
	
	const objectsOfType: {any} = self:GetObjectsOfType(typeName)
	
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
	const Tome = require("../Path/To/Tome")
	const newTome = Tome.new()
	
	const Players = game:GetService("Players")
	
	const function playerAdded(player: Player)
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
function Tome.Connect(self: Tome, signal: any, listener: (...any) -> ...any) : any
	if self:IsDestroying() then
		throwError(string.format(TOME_IS_DESTROYING_ERROR_MESSAGE, "connect to a signal"))
	end
	
	const realType: string = typeof(signal)
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
	const Tome = require("../Path/To/Tome")
	const newTome = Tome.new()
	
	const Players = game:GetService("Players")
	
	const function playerAdded(player: Player) : ()
		print(string.format("The first player to join was: %*", player.Name))
	end
	
	-- connects the playerAdded function to the Players.PlayerAdded signal
	-- once a player joins, the connection will disconnect
	newTome:Once(Players.PlayerAdded, playerAdded)
	```
	
]]
function Tome.Once(self: Tome, signal: RBXScriptSignal, listener: (...any) -> (...any)) : any
	if self:IsDestroying() then
		throwError(string.format(TOME_IS_DESTROYING_ERROR_MESSAGE, "connect once to a signal"))
	end
	
	const realType: string = typeof(signal)
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
	const Tome = require("../Path/To/Tome")
	const SomeClass = require("../Path/To/Tome")
	
	const newTome = Tome.new()
	
	const class = newTome:Construct(SomeClass, "Apple", "Banana", "Pear")
	
	-- will destroy the class object
	newTome:Destroy()
	```
	
	```luau
	const Tome = require("../Path/To/Tome")
	const SomeClass = require("../Path/To/Tome")
	
	const newTome = Tome.new()
	
	-- using the class constructor function as the first argument
	const class = newTome:Construct(SomeClass.new, "Apple", "Banana", "Pear")
	
	-- will destroy the class object
	newTome:Destroy()
	```
	
]]
function Tome.Construct(self: Tome, class: any, ...: any) : any
	if self:IsDestroying() then
		error(string.format(TOME_IS_DESTROYING_ERROR_MESSAGE, "construct a class"))
	end
	
	const classType: string = type(class)
	if classType == "table" then
		const constructFunction: (() -> ())? = class.new
		const functionType: string = type(constructFunction)
		
		if functionType == "function" and constructFunction then
			return self:FastAdd(constructFunction(...), nil)
		end
	end
	
	if classType == "function" then
		return self:FastAdd(class(...))
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
	const Tome = require("../Path/To/Tome")
	const SomeClass = require("../Path/To/Tome")
	
	const newTome = Tome.new()
	
	-- add the apple to the Tome
	newTome:Add(workspace.Apple)
	print(newTome:Has(workspace.Apple)) -> true
	
	-- duplicate the Tome
	const duplicateTome = newTome:Duplicate()
	print(duplicateTome:Has(workspace.Apple)) -> true
	
	-- destroys the apple as it existed within the duplicate Tome
	duplicateTome:Destroy()
	
	-- prints false because the apple was destroyed by the duplicate Tome
	print(newTome:Has(workspace.Apple)) -> false
	```
	
]]
function Tome.Duplicate(self: Tome) : Tome
	if self:IsDestroying() then
		error(string.format(TOME_IS_DESTROYING_ERROR_MESSAGE, "duplicate the Tome"))
	end
	
	const duplicateTome: Tome = Tome.new({
		FastAdd = self.__fastAdd,
		SpawnDestroy = self.__spawnDestroy,
		Warnings = self.__warnings,
		Tagging = self.__tagging,
		UseParentMetaprops = self.__useParentMetaprops,
	})
	
	duplicateTome.__objects = table.clone(self.__objects)
	
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
	const Tome = require("../Path/To/Tome")
	const newTome = Tome.new()
	
	const duplicateCube = newTome:Clone(workspace.Cube)
	
	-- will destroy the duplicate cube
	newTome:Destroy()
	```
	
	```luau
	const Tome = require("../Path/To/Tome")
	const SomeClass = require("../Path/To/Tome")
	
	const newTome = Tome.new()
	
	const class = newTome:Construct(SomeClass.new)
	const duplicateClass = newTome:Clone(class)
	
	-- both the class and duplicate class will be destroyed
	newTome:Destroy()
	```
	
]]
function Tome.Clone(self: Tome, object: any, extendFunctionName: string?) : any
	if self:IsDestroying() then
		error(string.format(TOME_IS_DESTROYING_ERROR_MESSAGE, "clone an object"))
	end
	
	const objectType: string = typeof(object)
	if objectType == "table" then
		const extensionFunction: ((object: any) -> ())? = extendFunctionName and object[extendFunctionName]
		if extensionFunction then
			return self:FastAdd(extensionFunction(object), nil :: DestroyMethod?)
		end
		
		for index: number, extensionName: string in EXTENSION_METHOD_NAMES do
			const extension: ((object: any) -> ())? = object[extensionName]
			if extension then
				return self:FastAdd(extension(object), nil)
			end
		end
		
		return throwError("Attempted to clone a table (most likely a class) however the table doesn't contain an extension/clone method.", "Ensure the provided class has en extension method. If it does, add it to the extension list at the top of the module.")
	elseif objectType == "Instance" then
		const clonedObject: any = object:Clone()
		if not self.__fastAdd then
			validateObject(clonedObject, self :: Tome)
		end
		
		self.__objects[clonedObject] = "Destroy"
		
		return clonedObject
	end
	
	error(string.format("Failed to clone object: %s", tostring(object)))
end

const INSTANCE_FORMAT_STRING: string = "\n\tAttempted to set property '%s' to an Instance created by Tome.\n\tReason: %*"

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
	const Tome = require("../Path/To/Tome")
	const newTome = Tome.new()
	
	const part = newTome:Instance("Part")
	part.Parent = workspace
	
	task.wait(2)
	
	newTome:Destroy() -- Destroys the part
	```
	
	```luau
	const Tome = require("../Path/To/Tome")
	const newTome = Tome.new()
	
	const part = newTome:Instance("Part", {
		Color = Color3.new(1, 1, 1),
		Size = Vector3.one,
		Parent = workspace,
	})
	
	task.wait(2)
	
	-- destroys the part
	newTome:Destroy()
	```
	
	```luau
	const Tome = require("../Path/To/Tome")
	const newTome = Tome.new()
	
	-- will throw an error as "Apple" isn't an actual instance type
	newTome:Instance("Apple")
	```
	
]]
function Tome.Instance(self: Tome, instanceName: string, properties: {[string]: any}?, destroyMethod: DestroyMethod?) : any
	assert(type(instanceName) == "string", "Expected argument #1 'instanceName' to be a string type.")
	assert(type(properties) == "table" or properties == nil, "Expected argument #2 'properties' to be a table type, or nil.")
	
	if self:IsDestroying() then
		error(string.format(TOME_IS_DESTROYING_ERROR_MESSAGE, "create an Instance"))
	end
	
	const result: Instance = Instance.new(instanceName)
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
				
				warn(string.format(INSTANCE_FORMAT_STRING, tostring(property), issue))
			end)
		end
	end
	
	self.__objects[result] = destroyMethod or "Destroy"
	
	return result
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
function Tome.FromExisting(self: Tome, instance: Instance, destroyMethod: DestroyMethod?) : any
	assert(typeof(instance) == "Instance", "Expected argument #1 'instance' to be an Instance type.")
	
	if self:IsDestroying() then
		error(string.format(TOME_IS_DESTROYING_ERROR_MESSAGE, "create an Instance from existing"))
	end
	
	const fromExisting: Instance = Instance.fromExisting(instance)
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
	const Tome = require("../Path/To/Tome")
	const newTome = Tome.new()
	
	const cube = workspace.Cube
	
	-- attach the Tome to the cube
	newTome:Attach(cube)
	
	-- will also destroy the Tome, as the Tome attached to the cube
	cube:Destroy()
	```
	
]]
function Tome.Attach(self: Tome, object: any) : Attachment?
	const objectType: string = realTypeOf(object)
	
	if objectType == "Tome" then
		return object:Add(self:WrapDestroy(), FunctionType)
	elseif objectType == "Instance" then
		if not object:IsDescendantOf(game) then
			return nil
		end
		
		-- bad up values should be changed at some point
		local wasDestroyed: boolean = false
		local wasNulled: boolean = false
		
		const destroyingConnection: RBXScriptConnection = object.Destroying:Connect(function()
			if wasDestroyed or wasNulled then
				return
			end
			
			wasDestroyed = true
			
			self:Destroy()
		end)
		
		const ancestryConnection: RBXScriptConnection = object.AncestryChanged:Connect(function()
			const descendantOfGame: boolean = object:IsDescendantOf(game)
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
	const cleanUp: () -> () = newTome:AttachTuple(workspace.Cube, workspace.Cube2)
	newTome:FastAdd(cleanUp, Tome.FunctionType)
	```
	
	Example(s):
	```luau
	const Tome = require("../Path/To/Tome")
	const newTome = Tome.new()
	
	newTome:AttachTuple(workspace.Cube, workspace.Cube2)
	newTome:Add(function()
		print("Either cube, or cube2 was destroyed!")
	end)
	
	workspace.Cube2:Destroy()
	```
	
	```luau
	const Tome = require("../Path/To/Tome")
	const newTome = Tome.new()
	
	-- use the variable to get the attachments
	const cleanUpAttachments: () -> () = newTome:AttachTuple(workspace.Cube, workspace.Cube2)
	
	newTome:Add(function()
		print("Either cube, or cube2 was destroyed!")
	end)
	
	cleanUpAttachments() -- clean up all the attachments, freeing any from the Tome as well
	
	-- nothing will happen since the attachments were cleaned up
	workspace.Cube:Destroy()
	workspace.Cube2:Destroy()
	```
	
	```luau
	const Tome = require("../Path/To/Tome")
	const newTome = Tome.new()
	
	-- use the variable to get the attachments
	const cleanUpAttachments: () -> (), attachments: {any} = newTome:AttachTuple(workspace.Cube, workspace.Cube2)
	
	newTome:Add(function()
		print("Either cube, or cube2 was destroyed!")
	end)
	
	attachments[1]:Disconnect() -- since cube is an instance, this will be a connection, so let's disconnect it
	
	-- destroy the cube and nothing will happen as we disconnected that specific attachemtn
	workspace.Cube:Destroy()
	```
	
]]
function Tome.AttachTuple(self: Tome, ...: any) : (() -> (), {Attachment})
	const attachments: {Attachment} = self:Table({})
	
	for index: number, object: any in {...} do
		const attachment: Attachment? = self:Attach(object)
		if not attachment then
			continue
		end
		
		table.insert(attachments, attachment)
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
	end, attachments
end

--[[
	
	@within Tome
	@param tag string
	@return void
	
	Destroys all the objects contained within the Tome that have the provided tag.
	
	Will throw an error if the Tome is in the middle of being destroyed.
	
	Example(s):
	```luau
	const Tome = require("../Path/To/Tome")
	const newTome = Tome.new()
	
	const apple, banana, pear = workspace.Apple, workspace.Banana, workspace.Pear
	
	-- add all the fruits
	newTome:AddTuple(apple, banana, pear)
	
	-- tag only the apple and banana
	apple:AddTag("SomeTag")
	banana:AddTag("SomeTag")
	
	-- destroys only the apple and banana. The pear remains as it wasn't tagged
	newTome:DestroyObjectsWithTag("SomeTag")
	```
	
]]
function Tome.DestroyObjectsWithTag(self: Tome, tag: string) : ()
	assert(type(tag) == "string", "Expected argument #1 'tag' to be a string type.")
	
	if self:IsDestroying() then
		error(string.format(TOME_IS_DESTROYING_ERROR_MESSAGE, string.format("destroy objects with tag: %s", tag)))
	end
	
	const collectedObjects: {Instance} = self:GetObjectsWithTag(tag)
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
	const Tome = require("../Path/To/Tome")
	const newTome = Tome.new()
	
	-- the apple is a model
	newTome:Add(workspace.Apple)
	
	-- the cube is a part
	newTome:Add(workspace.Cube)
	
	-- will object destroy the cube
	newTome:DestroyObjectsOfType("BasePart")
	```
	
]]
function Tome.DestroyObjectsOfType(self: Tome, typeName: string) : ()
	assert(type(typeName) == "string", "Expected argument #1 'typeName' to be a string type.")
	
	if self:IsDestroying() then
		error(string.format(TOME_IS_DESTROYING_ERROR_MESSAGE, string.format("destroy objects of class: %s", typeName)))
	end
	
	const collectedObjects: {any} = self:GetObjectsOfType(typeName)
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
	const Tome = require("../Path/To/Tome")
	const newTome = Tome.new()
	
	newTome:HookRunServiceSignal("RenderStepped", function(deltaTime: number)
		print(`[RenderStepped]: Time spent: {deltaTime}`)
	end)

	newTome:HookRunServiceSignal("Stepped", function(timeElapsed: number, deltaTime: number)
		print(`[Stepped]: Time elapsed: {timeElapsed} Time spent: {deltaTime}`)
	end)
	```

]]
function Tome.HookRunServiceSignal(self: Tome, signalName: RunServiceSignalName, listener: (deltaTime: number) -> () | (time: number, deltaTime: number) -> ()) : RBXScriptConnection
	assert(type(signalName) == "string", "Expected argument #1 'signalName' to be a string type.")
	assert(type(listener) == "function", "Expected argument #2 'listener' to be a function type.")
	
	const signal: RBXScriptSignal = assert((RunService :: any)[signalName], "Expected a RunService signal but got nil")
	
	return self:Connect(signal, listener)
end

const RENDER_STEP_METAMETHODS = {
	__call = function(self: RenderStepBinding)
		RunService:UnbindFromRenderStep(self.name)
		
		self.owner.__objects[self] = nil
	end
}

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
	const Tome = require("../Path/To/Tome")
	const newTome = Tome.new()
	
	const unbind: () -> () = newTome:BindRenderStepped("STEP", 1, function(deltaTime: number)
		print(`Time spent stepping... {deltaTime}`)
	end)
	
	-- unbinds the render stepped binding after 2 seconds
	task.delay(2, unbind)
	```
	
]]
function Tome.BindRenderStepped(self: Tome, name: string, renderPriority: number?, listener: (deltaTime: number) -> ()) : CallableRenderStepBinding
	assert(type(name) == "string", "Expected argument #1 'name' to be a number type.")
	assert(type(renderPriority) == "number" or renderPriority == nil, "Expected argument #2 'renderPriority' to be a number type, or nil.")
	assert(type(listener) == "function", "Expected argument #3 'listener' to be a function type.")
	
	if self:IsDestroying() then
		throwError(string.format(TOME_IS_DESTROYING_ERROR_MESSAGE, "bind to render step"))
	end
	
	RunService:BindToRenderStep(name, renderPriority or 1, listener)
	
	const object: RenderStepBinding = {
		name = name,
		owner = self,
	}
	
	setmetatable(object, RENDER_STEP_METAMETHODS)
	
	self.__objects[object] = function(renderStepBinding: RenderStepBinding)
		RunService:UnbindFromRenderStep(renderStepBinding.name)
	end
	
	return object
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
	const Tome = require("../Path/To/Tome")
	const newTome = Tome.new()
	
	newTome:BindRenderStepped("Test", 1, function(deltaTime: number)
		print(`Time spent: {deltaTime}`)
	end)
	
	task.wait(2)
	
	newTome:UnbindRenderStepped("Test")
	```
	
]]
function Tome.UnbindRenderStepped(self: Tome, name: string) : ()
	assert(type(name) == "string", "Expected argument #1 'name' to be a string type.")
	
	for object: any in self.__objects do
		if getmetatable(object) == RENDER_STEP_METAMETHODS and object.name == name then
			RunService:UnbindFromRenderStep(name)
			
			self.__objects[object] = nil
			
			break
		end
	end
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
	const Tome = require("../Path/To/Tome")
	const newTome = Tome.new()
	
	someTime:Delay(3, function()
		print("Destroyed the Tome")
	end)
	
	newTome:Destroy()
	```
	
]]
function Tome.Delay<vargs>(self: Tome, duration: number, listener: (...vargs) -> ...any, ...: vargs) : thread
	assert(type(duration) == "number", "Expected argument #1 'duration' to be a number type.")
	assert(type(listener) == "function", "Expected argument #2 'listener' to be a function type.")
	
	if self:IsDestroying() then
		error(string.format(TOME_IS_DESTROYING_ERROR_MESSAGE, "delay a thread"))
	end
	
	const delayedThread: thread = task.delay(duration, listener, ...)
	
	self.__objects[delayedThread] = ThreadType
	
	return delayedThread
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
	const Tome = require("../Path/To/Tome")
	const newTome = Tome.new()
	
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
function Tome.Spawn<vargs>(self: Tome, listener: (...vargs) -> ...any, ...: vargs) : thread
	assert(type(listener) == "function", "Expected argument #1 'listener' to be a function type.")
	
	if self:IsDestroying() then
		error(string.format(TOME_IS_DESTROYING_ERROR_MESSAGE, "spawn a thread"))
	end
	
	const spawnedThread: thread = task.spawn(listener, ...)
	
	self.__objects[spawnedThread] = ThreadType
	
	return spawnedThread
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
function Tome.Defer<vargs>(self: Tome, listener: (...vargs) -> ...any, ...: vargs) : thread
	assert(type(listener) == "function", "Expected argument #1 'listener' to be a function type.")
	
	if self:IsDestroying() then
		error(string.format(TOME_IS_DESTROYING_ERROR_MESSAGE, "defer a thread"))
	end
	
	const deferredThread: thread = task.defer(listener, ...)
	
	self.__objects[deferredThread] = ThreadType
	
	return deferredThread
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
	const Tome = require("../Path/To/Tome")
	const newTome = Tome.new()
	
	print("This prints instantly")

	newTome:DelayDestroy(1)
	newTome:Yield()

	print("This prints after ~1 second")
	```

]]
function Tome.Yield(self: Tome, thread: thread?) : ()
	const currentThread: thread = thread or coroutine.running()
	
	self.__objects[currentThread] = coroutine.resume
	
	return coroutine.yield()
end

--[[
	
	@within Tome
	@param object any
	@return boolean
	
	Checks if an object exists within the Tome.
	
	Example(s):
	```luau
	const Tome = require("../Path/To/Tome")
	const newTome = Tome.new()
	
	-- check if the cube exists initially, which it doesn't
	const exists: boolean = newTome:Contains(workspace.Cube)
	print(exists) -- false
	
	-- so we add the cube to the Tome
	newTome:Add(workspace.Cube)
	
	-- and now that the cube has been added, true is returned
	const exists: boolean = newTome:Contains(workspace.Cube)
	print(exists) -- true
	```
	
]]
function Tome.Contains(self: Tome, object: any) : boolean
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
	const Tome = require("../Path/To/Tome")
	const newTome = Tome.new()
	
	const signal = newTome:Signal()
	
	signal:Connect(function(argument: string)
		print(argument)
	end)
	
	-- fires like any signal
	signal:Fire("Hello, world!")
	
	-- destroy the signal manually (will remain in Tome memory until disposed)
	newTome:Destroy()
	```
	
]]
function Tome.Signal(self: Tome) : Signal.Signal
	if self:IsDestroying() then
		error(string.format(TOME_IS_DESTROYING_ERROR_MESSAGE, "construct a Signal"))
	end
	
	const signal: Signal.Signal = Signal.new()
	
	self.__objects[signal] = Signal.Destroy
	
	return signal
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
	const Tome = require("../Path/To/Tome")
	const newTome = Tome.new()
	
	const myTable: {[any]: any} = newTome:Table({})
	
	print(myTable)
	```
	
]]
function Tome.Table(self: Tome, existing: {[any]: any}?) : {[any]: any}
	if self:IsDestroying() then
		error(string.format(TOME_IS_DESTROYING_ERROR_MESSAGE, "add a table"))
	end
	
	const tableToUse: {[any]: any} = existing or {}
	
	self.__objects[tableToUse] = table.clear
	
	return tableToUse
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
	const Tome = require("../Path/To/Tome")
	const newTome = Tome.new()
	
	const tween: Tween = newTome:Tween(workspce.Cube, TweenInfo.new(1), { Size = Vector3.one * 4 }, { Play = true })

	const function completed() : ()
		print("Finished tween")
	end

	tween.Completed:Once(completed)
	```

]]
function Tome.Tween(
	self: Tome,
	instance: Instance,
	tweenInfo: TweenInfo,
	propertyTable: {[string]: any},
	metadata: TweenMetadata?
) : Tween
	assert(typeof(instance) == "Instance", "Expected argument #1 'instance' to be an Instance type.")
	assert(typeof(tweenInfo) == "TweenInfo", "Expected argument #2 'tweenInfo' to be a TweenInfo type.")
	assert(type(propertyTable) == "table", "Expected argument #3 'propertyTable' to be a table type.")
	assert(type(metadata) == "table" or metadata == nil, "Expected argument #4 'metadata' to be a table type, or nil.")
	
	if self:IsDestroying() then
		error(string.format(TOME_IS_DESTROYING_ERROR_MESSAGE, "create a Tween"))
	end
	
	const tween: Tween = TweenService:Create(instance, tweenInfo, propertyTable)
	
	self.__objects[tween] = TweenType
	
	if metadata then
		if metadata.RemoveOnComplete then
			const function tweenCompleted(playbackState: Enum.PlaybackState) : ()
				const tweenEnded: boolean = playbackState == Enum.PlaybackState.Completed
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
	const Tome = require("../Path/To/Tome")
	const newTome = Tome.new()
	
	const apple, banana = newTome:AddTuple(workspace.Apple, workspace.Banana)
	
	-- the apple will be destroyed
	newTome:DestroyObject(apple)
	```
	
	```luau
	const Tome = require("../Path/To/Tome")
	const newTome = Tome.new()
	
	const banana = workspace.Banana
	
	-- nothing will happen bceause the banana isn't inside the Tome
	newTome:DestroyObject(banana)
	```
	
]]
function Tome.DestroyObject(self: Tome, object: any) : boolean
	if self:IsDestroying() then
		error(string.format(TOME_IS_DESTROYING_ERROR_MESSAGE, "destroy object"))
	end
	
	const objects: {[any]: DestroyMethod} = self.__objects
	const destroyMethod: DestroyMethod? = objects[object]
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
	const Tome = require("../Path/To/Tome")
	const newTome = Tome.new()
	
	const apple, banana, pear = newTome:AddTuple(workspace.Apple, workspace.Banana, workspace.Pear)
	
	-- will only destroy the apple and banana
	newTome:DestroyTuple(apple, banana)
	```
	
]]
function Tome.DestroyTuple(self: Tome, ...: any) : ()
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
	const Tome = require("../Path/To/Tome")
	const newTome = Tome.new()
	
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
function Tome.CanDestroy(self: Tome) : boolean
	return not self.__destroying
end

--[[
	
	@within Tome
	@return boolean
	
	Returns whether or not the Tome is currently destroying.

	```luau
	const Tome = require("../Path/To/Tome")
	const newTome = Tome.new()
	
	if newTome:IsDestroying() then
		-- do nothing
	else
		newTome:Add(workspace.Cube)
	end
	```
	
]]
function Tome.IsDestroying(self: Tome) : boolean
	return self.__destroying
end

--[[
	
	@within Tome
	@return {[any]: DestroyMethod}
	
	Returns all the objects contained within the Tome. This should only be used to modify
	the objects and not destroy them directly.
	
	```luau
	const Tome = require("../Path/To/Tome")
	const newTome = Tome.new()
	
	newTome:AddTuple(workspace.Apple, workspace.Banana)
	
	print(newTome:GetObjects()) -> {[Instance(Apple,REF)] = "Destroy", [Instance(Banana,REF)] = "Destroy"}
	```
	
]]
function Tome.GetObjects(self: Tome) : {[any]: DestroyMethod}
	return self.__objects
end

--[[
	
	@within Tome
	@return number
	
	Returns the total amount of objects currectly inside the Tome
	
	```luau
	const Tome = require("../Path/To/Tome")
	const newTome = Tome.new()
	
	newTome:AddTuple(workspace.Apple, workspace.Banana, workspace.Pear)
	
	print(newTome:Count()) --> 3
	```
	
]]
function Tome.Count(self: Tome) : number
	local count: number = 0
	
	const objects: {[any]: DestroyMethod} = self.__objects
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
	const Tome = require("../Path/To/Tome")
	const newTome = Tome.new()
	
	newTome:Add(workspace.Apple)
	newTome:Connect(workspace.ChildAdded, print)
	newTome:Add(function() end)
	
	const objects = newTome:GetObjectsOfType("function")
	print(objects) -> {[1] = function(REF)}
	```
	
	```luau
	const Tome = require("../Path/To/Tome")
	const newTome = Tome.new()
	
	newTome:Add(workspace.Apple)
	newTome:Connect(workspace.ChildAdded, print)
	newTome:Tween(workspace.Cube, TweenInfo.new(5), { Size = Vector3.one })
	newTome:Tween(workspace.AnotherCube, TweenInfo.new(5), { Size = Vector3.one })
	
	const objects = newTome:GetObjectsOfType("Tween")
	print(objects) -> {[1] = Instance(Tween,REF), [2] = Instance(Tween,REF)}
	```
	
]]
function Tome.GetObjectsOfType(self: Tome, typeName: string) : {any}
	assert(type(typeName) == "string", "Expected argument #1 'typeName' to be a string type.")
	
	const objects: {[any]: DestroyMethod} = self.__objects
	const collectedObjects: {any} = {}
	
	for object: any in objects do
		const objectType: string = realTypeOf(object)
		
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
	const Tome = require("../Path/To/Tome")
	const newTome = Tome.new()
	
	-- set a custom tag (internally will be randomized if not set)
	newTome:SetTag("Demonstration")

	-- add the tag we just created
	const ourTag: string = newTome:GetTag()
	workspace.Cube:AddTag(ourTag)

	print(newTome:GetObjectsWithTag(ourTag)) -> {Instance(Part, REF)}
	```

]]
function Tome.GetObjectsWithTag(self: Tome, tag: string) : {Instance}
	assert(type(tag) == "string", "Expected argument #1 'tag' to be a string type.")
	
	const objects: {[any]: DestroyMethod} = self.__objects
	const collectedObjects: {Instance} = {}
	
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
	const Tome = require("../Path/To/Tome")
	const newTome = Tome.new()
	
	-- construct a new Page and add an "apple" object to it
	const somePage = newTome:AddPage()
	somePage:Add(workspace.Apple)
	
	-- add a "banana" object to the main Tome
	newTome:Add(workspace.Banana)
	
	-- destroys only the banana as the apple was contained within a Page
	newTome:DestroyAllObjects()
	```
	
]]
function Tome.DestroyAllObjects(self: Tome, __ignoreDestroyingProperty: boolean?) : ()
	if self:IsDestroying() and not __ignoreDestroyingProperty then
		error(string.format(TOME_IS_DESTROYING_ERROR_MESSAGE, "destroy all objects"))
	end
	
	const objects: {[any]: DestroyMethod} = self.__objects
	
	const spawnDestroy: boolean = self.__spawnDestroy
	const warnings: boolean = self.__warnings
	
	if spawnDestroy then
		for object: any, destroyMethod: any in objects do
			const success: boolean, result: any = pcall(task.spawn, destroyObject, object, destroyMethod)
			
			if not success and warnings then
				failedToDestroyObject(object, result)
			end
		end
	else
		for object: any, destroyMethod: any in objects do
			const success: boolean, result: any = pcall(destroyObject, object, destroyMethod)
			
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
	const Tome = require("../Path/To/Tome")
	const newTome = Tome.new()

	newTome:Add(workspace.Cube)
	
	const somePage = newTome:AddPage()
	somePage:Add(workspace.Cube2)
	
	newTome:DestroyAllPages()

	print(newTome:GetObjects()) -> {[Instance(Cube, REF)] Destroy}
	print(somePage:GetObjects()) -> {} -- cube 2 no longer remains

	```
]]
function Tome.DestroyAllPages(self: Tome, __ignoreDestroyingProperty: boolean?) : ()
	if self:IsDestroying() and not __ignoreDestroyingProperty then
		error(string.format(TOME_IS_DESTROYING_ERROR_MESSAGE, "destroy all Pages"))
	end
	
	-- TODO: Fix type issue when new solver gets released
	for pageName: string, page: any in self.__pages do
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
	const Tome = require("../Path/To/Tome")
	const newTome = Tome.new()
	
	newTome:Add(workspace.Apple)
	
	-- destroys the apple after 2 seconds
	newTome:DelayDestroy(2)
	```
	
	```luau
	const Tome = require("../Path/To/Tome")
	const newTome = Tome.new()
	
	newTome:Add(workspace.Apple)
	
	const tomeDestroyThread: thread = newTome:DelayDestroy(5)
	
	task.wait(2)
	
	-- this prevents the Tome from being destroyed as it suspends the thread
	task.cancel(tomeDestroyThread)
	```
	
]]
function Tome.DelayDestroy(self: Tome, duration: number) : thread
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
	const Tome = require("../Path/To/Tome")
	const newTome = Tome.new()
	
	const destroyTome: () -> () = newTome:WrapDestroy()
	
	-- destroys the Tome as though invoking Tome:Destroy
	destroyTome()
	```
	
]]
function Tome.WrapDestroy(self: Tome) : () -> ()
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
	const Tome = require("../Path/To/Tome")
	const newTome = Tome.new()
	
	newTome:OnDestroy(function()
		print("This Tome has finished destroying itself")
	end)
	
	newTome:Destroy()
	```
	
	```luau
	const Tome = require("../Path/To/Tome")
	const newTome = Tome.new()
	
	const unattachCallback: () -> () = newTome:OnDestroy(function()
		print("This Tome has finished destroying itself")
	end)
	
	-- removes the callback from the Tome
	unattachCallback()
	
	newTome:Destroy()
	```
	
]]
function Tome.OnDestroy(self: Tome, callback: (...any) -> (), onDestroyParams: OnDestroyParams?) : () -> ()
	assert(type(callback) == "function", "Expected argument #1 'callback' to be a function type.")
	assert(type(onDestroyParams) == "table" or onDestroyParams == nil, "Expected argument #2 'onDestroyParams' to be a table type, or nil.")
	
	if self:IsDestroying() then
		error(string.format(TOME_IS_DESTROYING_ERROR_MESSAGE, "attach a destroy callback"))
	end
	
	const destroyCallbackData: OnDestroyCallbackData = {
		callback = callback,
		OnDestroyParams = onDestroyParams or {
			Synchronous = true,
		},
	}
	
	table.insert(self.__destroyCallbacks, destroyCallbackData)
	
	return function()
		const index: number? = table.find(self.__destroyCallbacks, destroyCallbackData)
		if index then
			table.remove(self.__destroyCallbacks, index)
		end
	end
end

do
	const deferThread: (...any) -> () = task.defer
	const spawnThread: (...any) -> () = task.spawn
	
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
		const Tome = require("../Path/To/Tome")
		const newTome = Tome.new()
		
		-- add a cube to the Tome
		newTome:Add(workspace.Cube)
		
		-- destroys the Tome, which in this case will destroy the cube
		newTome:Destroy()
		```
		
	]]
	function Tome.Destroy(self: Tome, ...: any) : ()
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
			const callback: (...any) -> () = callbackData.callback
			const onDestroyParams: OnDestroyParams = callbackData.OnDestroyParams
			
			if onDestroyParams.Synchronous then
				callback(...)
			else
				(onDestroyParams.Deferred and deferThread or spawnThread)(callback, ...)
			end
			
			if onDestroyParams.RemoveOnDestroy then
				table.remove(self.__destroyCallbacks, index)
			end
		end
	end
end

--[[
	
	@metamethod
	@within Tome
	@return void
	
	Metamethod for Tome.
	
	Allows the Tome to be destroyed when calling the table. Slightly slower than
	manually calling Tome:Destroy, but useful in environments where functions are
	required for clean up.
	
	Example(s):
	```luau
	const Tome = require("../Path/To/Tome")
	const newTome = Tome.new()
	
	newTome:Add(function()
		print("Tome destroyed")
	end)
	
	newTome() -- destroys the Tome, calling the function above
	```
	
]]
function Tome.__call(self: any, ...: any) : ()
	self:Destroy(...)
end

--[[
	
	@metamethod
	@within Tome
	@param object any
	@return object
	
	Adds an object to the Tome using the + math operator.
	Includes metatable index overhead, but is convenient when wanting to write faster.
	
	Example(s):
	```luau
	const Tome = require("../Path/To/Tome")
	const newTome = Tome.new()
	
	const part: Part = newTome + workspace.Part -- adds the part to the Tome
	print(part:GetFullName())
	```
	
]]
function Tome.__add<object>(self: Tome, object: object) : object
	return self:Add(object, nil)
end

--[[
	
	@metamethod
	@within Tome
	@param object object
	@return object
	
	Removes the object from the Tome using the - math operator.
	Includes metatable index overhead, but is convenient when wanting to write faster.
	
	Example(s):
	```luau
	const Tome = require("../Path/To/Tome")
	const newTome = Tome.new()
	
	const part: Part = newTome + workspace.Part
	print(newTome:Contains(part)) --> true
	
	const part: Part = newTome - workspace.Part
	print(newTome:Contains(part)) --> false
	```
	
]]
function Tome.__sub<object>(self: Tome, object: object) : object
	return self:Remove(object)
end

--[[
	
	@metamethod
	@within Tome
	@return number
	
	Returns the amount of objects inside the Tome.
	Includes metatable index overhead, but is convenient when wanting to write faster.
	Alternatively you can use `Tome:Count()` to return the amount of objects.
	
	Example(s):
	```luau
	const Tome = require("../Path/To/Tome")
	const newTome = Tome.new()
	
	newTome:Add(workspace.Part)
	newTome:Add(workspace.Part2)
	
	print(#newTome)
	```
	
]]
function Tome.__len(self: Tome) : number
	local count: number = 0
	
	for object: any in self.__objects do
		count += 1
	end
	
	return count
end

--[[
	
	@metamethod
	@within Tome
	@return () -> (object, DestroyMethod)
	
	Returns an iterator function that goes over all the objects
	inside the Tome.
	
	Example(s):
	```luau
	const Tome = require("../Path/To/Tome")
	const newTome = Tome.new()
	
	newTome:Add(workspace.Part)
	newTome:Add(workspace.Part2)
	
	for object: any, destroyMethod: Tome.DestroyMethod in newTome do
		print(object, destroyMethod)
	end
	
	-- Output:
	Part, "Destroy"
	Part2, "Destroy"
	```
]]
function Tome.__iter(self: Tome) : () -> (any, DestroyMethod)
	local currentObject: any = nil
	const objects: {[any]: DestroyMethod} = self.__objects
	
	return function()
		currentObject = next(objects, currentObject)
		
		if currentObject then
			return currentObject, objects[currentObject]
		end
		
		return nil, nil :: any
	end
end

return Tome