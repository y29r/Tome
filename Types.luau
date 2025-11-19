--!strict

export type DestroyMethod = (
	(object: any) -> ()
) |
(
	"Destroy" |
	"cancel" |
	"Disconnect" |
	string
)

export type Promise = {
	getStatus: (self: Promise) -> string,
	finally: (self: Promise, callback: () -> ()) -> (),
	cancel: (self: Promise) -> (),
}

export type TweenMetadata = {
	Play: boolean?,
	RemoveOnComplete: boolean?,
	RemoveOnDestroy: boolean?,
}

export type CallbackData = {
	synchronous: boolean?,
	deferred: boolean?,
	callback: (...any) -> (),
}

export type Metaprops = {
	Fast: boolean?,
	FastDestroy: boolean?,
	Warnings: boolean?,
	Tagging: boolean?,
	UseParentMetaprops: boolean?,
}

export type Tome = {
	__fast: boolean,
	__fastDestroy: boolean,
	__warnings: boolean,
	__tagging: boolean,
	
	__pages: {},
	__objects: {},
	
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
	FastAdd: <object>(self: Tome, object: object, destroyMethod: DestroyMethod?) -> object,
	AddTuple: <object...>(self: Tome, object...) -> object...,
	AddFromArray: <objectsArray>(self: Tome, objectsArray: objectsArray) -> objectsArray,
	AddPromise: (self: Tome, promise: Promise) -> any,
	
	Construct: (self: Tome, class: any, ...any) -> any,
	Duplicate: (self: Tome) -> Tome,
	Clone: (self: Tome, object: any, extendFunctionName: string?) -> any,
	Instance: (self: Tome, instanceName: string, properties: {[string]: any}?) -> Instance,
	FromExisting: (self: Tome, instance: Instance) -> Instance,
	Attach: (self: Tome, object: any) -> (RBXScriptSignal | () -> ())?,
	
	RenderStepped: (self: Tome, listener: (deltaTime: number) -> ()) -> RBXScriptConnection,
	BindRenderStepped: (self: Tome, name: string, renderPriority: number?, listener: (deltaTime: number) -> ()) -> () -> (),
	UnbindRenderStepped: (self: Tome, name: string) -> (),
	Heartbeat: (self: Tome, listener: (deltaTime: number) -> ()) -> RBXScriptConnection,
	
	Delay: (self: Tome, duration: number, listener: (...any) -> (...any), ...any) -> thread,
	Spawn: (self: Tome, listener: (...any) -> (...any), ...any) -> thread,
	Defer: (self: Tome, listener: (...any) -> (...any), ...any) -> thread,
	
	Find: (self: Tome, object: any) -> boolean,
	Has: (self: Tome, object: any) -> boolean,
	
	Signal: (self: Tome) -> any,
	
	Table: (self: Tome, existing: {}?) -> {},
	
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
	RemoveObjectsOfClass: (self: Tome, className: string) -> (),
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
	GetObjectsOfClass: (self: Tome, className: string) -> {any},
	GetObjectsWithTag: (self: Tome, tag: string) -> {any},
	
	Count: (self: Tome) -> number,
	
	DestroyObjectsWithTag: (self: Tome, tag: string) -> (),
	DestroyObjectsOfClass: (self: Tome, className: string) -> (),
	DestroyObject: (self: Tome, object: any) -> (),
	DestroyObjects: (self: Tome, ...any) -> (),
	DestroyAllObjects: (self: Tome, __ignoreDestroyingProperty: boolean?) -> (),
	DestroyAllPages: (self: Tome, __ignoreDestroyingProperty: boolean?) -> (),
	
	IsDestroying: (self: Tome) -> boolean,
	CanDestroy: (self: Tome) -> boolean,
	Destroy: (self: Tome, ...any) -> (),
	DelayDestroy: (self: Tome, duration: number) -> thread,
	WrapDestroy: (self: Tome) -> () -> (),
	OnDestroy: (self: Tome, callback: (...any) -> (), synchronous: boolean?, deferred: boolean?) -> () -> (),
	
	__connectTagRemoved: (self: Tome) -> (),
	__disconnectTagRemovedConnection: (self: Tome) -> (),
	__getTagRemovedConnection: (self: Tome) -> RBXScriptConnection?,
	
	__findPage: (self: Tome, pageToFind: Tome) -> (Tome?, Tome?),
	__getLastParentTome: (self: Tome) -> Tome?,
	__remove: <object>(self: Tome, object: object) -> object,
}

return table.freeze({})