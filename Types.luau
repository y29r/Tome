--!strict

local SignalTypes = require("./Signal/Types")

export type DestroyMethod = (
	(object: any) -> ()
) |
(
	"Destroy" |
	"cancel" |
	"Disconnect" |
	string
) | {}

export type Attachment = RBXScriptConnection | SignalTypes.Connection | () -> ()

export type Promise = {
	getStatus: (self: Promise) -> string,
	finally: (self: Promise, callback: () -> ()) -> (),
	cancel: (self: Promise) -> (),
}

export type RunServiceSignalName = "RenderStepped"
| "Heartbeat"
| "PostSimulation"
| "PreAnimation"
| "PreRender"
| "PreSimulation"
| "Stepped"

export type TweenMetadata = {
	Play: boolean?,
	RemoveOnComplete: boolean?,
}

export type OnDestroyCallbackData = {
	OnDestroyParams: OnDestroyParams,
	callback: (...any) -> (),
}

export type OnDestroyParams = {
	Synchronous: boolean?,
	Deferred: boolean?,
	RemoveOnDestroy: boolean?,
}

export type Metaprops = {
	FastAdd: boolean?,
	SpawnDestroy: boolean?,
	Warnings: boolean?,
	Tagging: boolean?,
	UseParentMetaprops: boolean?,
}

export type Tome = {
	__fastAdd: boolean,
	__spawnDestroy: boolean,
	__warnings: boolean,
	__tagging: boolean,
	
	__pages: {[string?]: Tome},
	__objects: {[any]: DestroyMethod},
	
	__destroying: boolean,
	__name: string?,
	__parentTome: Tome?,
	__tomeTag: string?,
	__useParentMetaprops: boolean,
	__tagRemovedConnection: RBXScriptConnection?,
	__destroyCallbacks: {[number]: (() -> ())},
	
	new: (metaprops: Metaprops?) -> Tome,
	
	SetTag: (self: Tome, tag: string) -> Tome,
	GetTag: (self: Tome) -> string?,
	
	Rename: (self: Tome, name: string?) -> Tome,
	
	Add: <object>(self: Tome, object: object, destroyMethod: DestroyMethod?) -> object,
	AddWithMiddleware: <object>(self: Tome, object: object, middleware: (object: object, complete: () -> ()) -> (), destroyMethod: DestroyMethod?) -> object,
	FastAdd: <object>(self: Tome, object: object, destroyMethod: DestroyMethod?) -> object,
	AddTuple: <object...>(self: Tome, object...) -> object...,
	AddFromArray: <objectsArray>(self: Tome, objectsArray: objectsArray) -> objectsArray,
	AddPromise: (self: Tome, promise: Promise) -> any,
	
	Construct: (self: Tome, class: any, ...any) -> any,
	Duplicate: (self: Tome) -> Tome,
	Clone: (self: Tome, object: any, extendFunctionName: string?) -> any,
	Instance: (self: Tome, instanceName: string, properties: {[string]: any}?) -> Instance,
	FromExisting: (self: Tome, instance: Instance) -> Instance,
	Attach: (self: Tome, object: any) -> () -> (),
	AttachTuple: (self: Tome, ...any) -> (() -> (), {Attachment}),
	
	HookRunServiceSignal: (self: Tome, signalName: RunServiceSignalName, listener: (deltaTime: number) -> () | (time: number, deltaTime: number) -> ()) -> RBXScriptConnection,
	BindRenderStepped: (self: Tome, name: string, renderPriority: number?, listener: (deltaTime: number) -> ()) -> () -> (),
	UnbindRenderStepped: (self: Tome, name: string) -> (),
	
	Delay: <vargs>(self: Tome, duration: number, listener: (...vargs) -> ...any, ...vargs) -> thread,
	Spawn: <vargs>(self: Tome, listener: (...vargs) -> ...any, ...vargs) -> thread,
	Defer: <vargs>(self: Tome, listener: (...vargs) -> ...any, ...vargs) -> thread,
	Yield: (self: Tome, thread: thread?) -> (),
	
	Contains: (self: Tome, object: any) -> boolean,
	Has: (self: Tome, object: any) -> boolean,
	
	Signal: (self: Tome) -> any,
	
	Table: (self: Tome, existing: {[any]: any}?) -> {[any]: any},
	
	Tween: (
		self: Tome,
		instance: Instance,
		tweenInfo: TweenInfo,
		propertyTable: {[string]: any},
		metadata: TweenMetadata?
	) -> Tween,
	
	Remove: <object>(self: Tome, object: object) -> object,
	RemoveTuple: <T...>(self: Tome, T...) -> T...,
	RemoveFromArray: <objectsArray>(self: Tome, objectsArray: objectsArray) -> objectsArray,
	RemoveObjectsWithTag: (self: Tome, tag: string) -> (),
	RemoveObjectsOfType: (self: Tome, typeName: string) -> (),
	Connect: (self: Tome, signal: any, listener: (...any) -> (...any)) -> any,
	Once: (self: Tome, signal: any, listener: (...any) -> (...any)) -> any,
	
	AddPage: (self: Tome, name: string?, metaprops: Metaprops?) -> Tome,
	extend: (self: Tome, name: string?, metaprops: Metaprops?) -> Tome,
	Extend: (self: Tome, name: string?, metaprops: Metaprops?) -> Tome,
	
	RipPage: (self: Tome, nameOrPage: string | Tome) -> (),
	RipPages: (self: Tome) -> (),
	
	GetPage: (self: Tome, name: string) -> Tome?,
	Parent: (self: Tome, newTome: Tome?) -> Tome,
	
	GivePage: (self: Tome, page: Tome, newTome: Tome) -> Tome,
	Move: <object>(self: Tome, object: object, otherTome: Tome) -> object,
	
	GetParentTome: (self: Tome) -> Tome?,
	GetObjects: (self: Tome) -> {[any]: any},
	GetObjectsOfType: (self: Tome, typeName: string) -> {any},
	GetObjectsWithTag: (self: Tome, tag: string) -> {any},
	
	Count: (self: Tome) -> number,
	
	DestroyObjectsWithTag: (self: Tome, tag: string) -> (),
	DestroyObjectsOfType: (self: Tome, typeName: string) -> (),
	DestroyObject: (self: Tome, object: any) -> (),
	DestroyObjects: (self: Tome, ...any) -> (),
	DestroyAllObjects: (self: Tome, __ignoreDestroyingProperty: boolean?) -> (),
	DestroyAllPages: (self: Tome, __ignoreDestroyingProperty: boolean?) -> (),
	
	IsDestroying: (self: Tome) -> boolean,
	CanDestroy: (self: Tome) -> boolean,
	Destroy: (self: Tome, ...any) -> (),
	DelayDestroy: (self: Tome, duration: number) -> thread,
	WrapDestroy: (self: Tome) -> () -> (),
	OnDestroy: (self: Tome, callback: (...any) -> (), onDestroyParams: OnDestroyParams?) -> () -> (),
	
	__connectTagRemoved: (self: Tome) -> (),
	__disconnectTagRemovedConnection: (self: Tome) -> (),
	
	__findPage: (self: Tome, pageToFind: Tome) -> (Tome?, Tome?),
	__getLastParentTome: (self: Tome) -> Tome?,
	__remove: <object>(self: Tome, object: object) -> object,
}

return false