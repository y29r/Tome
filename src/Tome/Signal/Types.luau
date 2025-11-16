--!strict

export type ConnectionListener = (...any) -> ()

export type Connection = {
	__listeners: {[ConnectionListener]: boolean},
	
	Connected: boolean,
	
	new: () -> Connection,
	
	__addListener: (self: Connection, listener: ConnectionListener) -> Connection,
	
	Disconnect: (self: Connection) -> (),
}

export type SignalListener = (...any) -> ()

export type Signal = {
	__activeListeners: {[SignalListener]: boolean?},
	__activeConnections: {[Connection]: boolean?},
	__onceListeners: {[SignalListener]: boolean?},
	__onceConnections: {[Connection]: boolean?},
	__waitingListeners: {[SignalListener | string]: thread},
	__isActive: boolean,
	
	Fire: (self: Signal, ...any) -> Signal,
	Connect: (self: Signal, listener: SignalListener) -> Connection,
	Once: (self: Signal, listener: SignalListener) -> Connection,
	Wait: (self: Signal, listener: SignalListener?) -> ...any,
	IsActive: (self: Signal) -> boolean,
	DisconnectAll: (self: Signal) -> (),
	Destroy: (self: Signal, shouldResumeThreads: boolean?) -> (),
	
	__resumeThreads: (self: Signal, ...any) -> (),
}

return table.freeze({})