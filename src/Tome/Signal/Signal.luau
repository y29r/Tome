--!strict
-- Author : @bytenand (Git)
-- Date : 03(D)/10(M)/2024(Y)

local HttpService = game:GetService("HttpService")

local Types = require("./Types")

local Connection = {}
Connection.__index = Connection
Connection.__type = "Connection"

function Connection.new() : Types.Connection
	local self = setmetatable({
		__listeners = {},
		Connected = true,
	}, Connection) :: any
	
	return self :: Types.Connection
end

--[[
	
	Connection:_addListener(listener: () -> nil) : Connection
	
	Adds a listener to when the connection will disconnect. Typically
	this is only used internally and shouldn't be used outside this
	scope.
	
]]
function Connection:__addListener(listener: Types.ConnectionListener) : Types.Connection
	self.__listeners[listener] = true
	
	return self
end

--[[
	
	Connection:Disconnect() : nil
	
	"Disconnects" the Connection. In other words, iterates through all the
	listeners and runs them within another thread. Typically the listeners
	only exist to know when to disconnect an actual RBXScriptSignal.
	
	Will also set the Connected property of the Connection to false to
	tackle certain edge cases.
	
]]
function Connection:Disconnect() : ()
	for listener in self.__listeners do
		task.spawn(listener)
	end
	
	self.Connected = false
end

local Signal = {}
Signal.__index = Signal
Signal.__type = "Signal"

function Signal.new() : Types.Signal
	local self = setmetatable({
		__activeListeners = {},
		__activeConnections = {},
		__onceListeners = {},
		__onceConnections = {},
		__waitingListeners = {},
		__isActive = true,
	}, Signal) :: any
	
	return self :: Types.Signal
end

local function callListenersOfTable(listenerHash: {[Types.SignalListener]: any}, ...: any) : ()
	for listener: Types.SignalListener in listenerHash do
		task.spawn(listener, ...)
	end
end

local function disconnectAllConnections(connectionHash: {[Types.Connection]: boolean}) : ()
	for connection: Types.Connection in connectionHash do
		if not connection.Connected then
			continue
		end
		
		connection:Disconnect()
	end
end

--[[
	
	Signal:__resumeThreads(...:any) : nil
	
	An internal method used to resume any paused threads which may
	have occured from the :Wait method.
	
	This shouldn't be ran outside this module as things may work
	in an unexpected manner.
	
]]

function Signal:__resumeThreads(...: any) : ()
	for listener: Types.SignalListener | string, thread: thread in self.__waitingListeners do
		if type(listener) == "function" then
			task.spawn(listener, ...)
		end
		
		local success: boolean, errorMessage: string = coroutine.resume(thread)
		if not success then
			local threadName: string = tostring(thread)
			
			warn(string.format("Failed to resume thread. Error message: %* | %*", errorMessage, threadName))
		end
	end
	
	table.clear(self.__waitingListeners)
end

--[[
	
	Signal:Fire(...) : nil
	
	Fires the Signal and passes any arguments passed to the listener Connections.
	If the Signal isn't active (due to being destroyed) and the method is called
	an error will be thrown.
	
	```lua
	local signal = Signal.new()
	
	signal:Connect(function(first, second)
		print(first, second) -> "Hello,", " world!"
	end)
	
	signal:Fire("Hello,", " world!")
	```
	
]]
function Signal:Fire(...: any) : Types.Signal
	if not self.__isActive then
		error("Attempted to fire a signal that is no longer active.")
	end
	
	callListenersOfTable(self.__activeListeners, ...)
	callListenersOfTable(self.__onceListeners, ...)
	
	table.clear(self.__onceListeners)
	
	disconnectAllConnections(self.__onceConnections)
	
	table.clear(self.__onceConnections)
	
	self:__resumeThreads(...)
	
	return self
end

--[[
	
	Signal:Connect(listener: (...any) -> nil) : Connection
	
	Creates a Connection for the Signal and the listener function passed
	in will listen for when the Signal has been fired.
	
	A Connection will be returned which can be disconnected. Upon the
	Connection being disconnected, the listener will be removed from
	the Signal's listeners table.
	
	```lua
	local signal = Signal.new()
	
	local connection = signal:Connect(function(something)
		print(something)
	end)
	
	signal:Fire("Something")
	
	``` -> "Something"
	
	```lua
	local signal = Signal.new()
	
	local connection = signal:Connect(function(something)
		print(something)
	end)
	
	-- disconnect the connection removing it from the Signal
	connection:Disconnect()
	
	signal:Fire("Something")
	
	``` -> nil (because the Connection was disconnected before the Signal was fired)
	
]]
function Signal:Connect(listener: Types.SignalListener) : Types.Connection
	assert(type(listener) == "function", "Signal:Connect listener argument must be a function type")
	assert(self.__isActive, "Attempted to connect to a Signal that is inactive.")
	
	local activeListeners: {[Types.SignalListener]: boolean?} = self.__activeListeners
	local activeConnections: {[Types.Connection]: boolean?} = self.__activeConnections
	
	activeListeners[listener] = true
	
	local connection: Types.Connection = Connection.new()
	
	connection:__addListener(function()
		activeListeners[listener] = nil
		activeConnections[connection] = nil
	end)
	
	activeConnections[connection] = true
	
	return connection
end

--[[
	
	Signal:Once(listener: (...any) -> nil) : Connection
	
	Does the exact same thing as Signal:Connect, however it
	will only listen for the Signal to fire once, and once
	it does, it will self disconnect itself.
	
	```lua
	local signal = Signal.new()
	
	local connection = signal:Once(function(something)
		print(something)
	end)
	
	signal:Fire("Something1")
	signal:Fire("Something2")
	signal:Fire("Something3")
	
	``` -> "Something1" (Only "Something1" is printed because the connection disconnected itself after the first fire)
	
	```lua
	local signal = Signal.new()
	
	local connection = signal:Once(function(something)
		print(something)
	end)
	
	-- Disconnect the connection
	connection:Disconnect()
	
	signal:Fire("Something1")
	signal:Fire("Something2")
	signal:Fire("Something3")
	
	``` -> nil (Since the Connection was disconnected before any fire methods were called)
	
]]
function Signal:Once(listener: Types.SignalListener) : Types.Connection
	assert(type(listener) == "function", "Signal:Once listener argument must be a function type")
	assert(self.__isActive, "Attempted to connect once to a Signal that is inactive.")
	
	local onceListeners: {[Types.SignalListener]: boolean?} = self.__onceListeners
	local onceConnections: {[Types.Connection]: boolean?} = self.__onceConnections
	
	onceListeners[listener] = true
	
	local connection: Types.Connection = Connection.new()
	
	connection:__addListener(function()
		onceListeners[listener] = nil
		onceConnections[connection] = nil
	end)
	
	onceConnections[connection] = true
	
	return connection
end

--[[
	
	Signal:Wait(listener: (...any) -> nil) : nil
	
	Acquires the current thread, stores it within the waiting listeners
	table and yields the current thread. The only way for the current
	thread to unyield is via :Fire.
	
]]
function Signal:Wait(listener: Types.SignalListener?) : ...any
	local currentThread: thread = coroutine.running()
	
	if listener then
		self.__waitingListeners[listener] = currentThread
	else
		self.__waitingListeners[HttpService:GenerateGUID(false)] = currentThread
	end
	
	return coroutine.yield()
end

--[[
	
	Signal:IsActive() : boolean
	
	Returns whether the Signal is active or not
	
]]
function Signal:IsActive() : boolean
	return self.__isActive
end

--[[
	
	Signal:DisconnectAll() : nil
	
	Disconnects any connections attached to the Signal. "Once" connections
	take priority over standard connections.
	
]]
function Signal:DisconnectAll() : ()
	disconnectAllConnections(self.__onceConnections)
	disconnectAllConnections(self.__activeConnections)
end

--[[
	
	Signal:Destroy(shouldResumeThreads: boolean?) : nil
	
	Destroys the Signal and removes any listeners. Takes in a
	shouldRemoveThreads argument which determines whether the
	threads should be resumed before the Signal is completely destroyed.
	
]]
function Signal:Destroy(shouldResumeThreads: boolean?) : ()
	shouldResumeThreads = shouldResumeThreads == nil
		and true
		or shouldResumeThreads
	
	table.clear(self.__activeListeners)
	table.clear(self.__onceListeners)
	table.clear(self.__onceConnections)
	
	self.__isActive = false
	
	if shouldResumeThreads then
		self:__resumeThreads()
	end
end

return Signal