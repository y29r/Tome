# Tome
An object-oriented garbage collection module for luau

## Methods
- `Tome.new` : Instantiates a new Tome with provides these methods:
	- `Tome:Add` : Adds an object to the Tome.
	- `Tome:AddTuple` : Adds tuple objects to the Tome.
	- `Tome:AddFromArray` : Adds objects from an array to the Tome.
	- `Tome:AddPromise` : Adds a standard Promise to the Tome.
	- `Tome:AddPage` : Constructs a Page (alias for Tome) and adds it to the Tome.
	- `Tome:Attach` : Attaches the Tome to an object. When the object is destroyed, the Tome will destroy too.
	- `Tome:AttachTuple` : Same as Tome:Attach but tuple objects can be passed.
	- `Tome:BindRenderStepped` : Binds to the RunService:BindToRenderStep method.
	- `Tome:CanDestroy` : Returns whether the Tome can be destroyed or not.
	- `Tome:Clone` : `:Clone`s an object and adds it to the Tome.
	- `Tome:Connect` : Connects a function to a Signal and adds that connection to the Tome.
	- `Tome:Once` : Connects a function to a Signal once and adds that connection to the Tome.
	- `Tome:Construct` : Constructs a custom class (via `Class.new`) and adds it to the Tome.
	- `Tome:Delay` : Creates a thread via `task.delay` and adds that thread to the Tome.
	- `Tome:extend` : Alias for `Tome:AddPage`.
	- `Tome:Extend` : Alias for `Tome:AddPage`.
	- `Tome:Spawn` : Creates a thread via `task.spawn` and adds that thread to the Tome.
	- `Tome:Defer` : Creates a thread via `task.defer` and adds that thread to the Tome.
	- `Tome:DelayDestroy` : Destroys the Tome after a specified duration.
	- `Tome:Destroy` : Destroys the Tome (calls `Tome:DestroyAllObjects` and `Tome:DestroyAllPages` internally, alongside calling all `:OnDestroy` callback hooks)
	- `Tome:DestroyAllObjects` : Destroys all the objects within the Tome.
	- `Tome:DestroyAllPages` : Destroys all the Pages within the Tome.
	- `Tome:DestroyObject` : Destroys the provided object if it exists within the Tome.
	- `Tome:DestroyObjects` : Destroys the provided objects if they exist within the Tome.
	- `Tome:DestroyObjectsWithTag` : Destroys all the objects in the Tome that have the specified tag.
	- `Tome:DestroyObjectsOfType` : Destroys all the objects in the Tome that have the specified type (`Instance`s will use `:IsA` methods to check elgibility)
	- `Tome:Contains` : Returns whether the specified object exists in the Tome.
	- `Tome:Has` : Alias for `Tome:Contains`.
	- `Tome:FromExisting` : Creates an Instance with `Instance.fromExisting` and adds it to the Tome.
	- `Tome:GetObjects` : Returns all the objects within the Tome.
	- `Tome:GetObjectsWithTag` : Returns all the objects within the Tome that have the given tag.
	- `TOme:GetObjectsOfType` : Returns all the objects of a specified type name.
	- `Tome:GetPage` : Returns a Page from the Tome given a name.
	- `Tome:GetParentTome` : Gets the parent Tome (if it has one)
	- `Tome:GetTag` : Returns the internal tag the Tome uses to automatically remove destroyed instances via [Tagging](https://github.com/y29r/Tome/blob/main/README.md#tagging).
	- `Tome:GivePage` : Moves a Page into another Tome.
	- `Tome:HookRunServceSignal` : Connects to any of the RunService signals given a name and adds the connection into the Tome.
	- `Tome:Instance` : Creates an Instance with `Instance.new` and adds it to the Tome.
	- `Tome:IsDestroying` : Returns whether the Tome is currently in a destroying state.
	- `Tome:Move` : Moves an object from the current Tome into another.
	- `Tome:Parent` : Parents the Tome to another Tome.
	- `Tome:Remove` : Removes an object from the Tome (will **not** destroy it)
	- `Tome:RemoveTuple` : Removes multiple objects from the Tome.
	- `Tome:RemoveFromArray` : Removes objects from an array of objects from the Tome.
	- `Tome:RemoveObjectsWithTag` : Removes objects with a specified tag from the Tome.
	- `Tome:RemoveObjectsOfType` : Removes objects of a specified type from the Tome.
	- `Tome:Rename` : Renames the Tome.
	- `Tome:RipPage` : Destroys the provided page and removes it from the Tome.
	- `Tome:RipPages` : Destroys and removes all the Pages within a Tome.
	- `Tome:SetTag` : Overrides the default Tome tag used for [Tagging](https://github.com/y29r/Tome/blob/main/README.md#tagging).
	- `Tome:Signal` : Constructs a standard Signal and adds it to the Tome and returns it.
	- `Tome:UnbindRenderStepped` : Unbinds a binding made with `Tome:BindRenderStepped`.
	- `Tome:Tween` : Creates a Tween and adds it to the Tome. (Includes extra features mentioned within [Tome-main](https://github.com/y29r/Tome/blob/main/Tome.luau))
	- `Tome:Table` : Adds a table inside the Tome and uses `table.clear` as the destroy method.
	- `Tome:OnDestroy` : Attaches a callback that listens for when the Tome destroys. This callback does **NOT** get cleaned up by default, however you can provide this with the params as well as manually cleaning it up. 
- `Tome.Is` : Returns whether the provided object is a Tome object or not.
- `Tome.schedule` : Schedules an object to be removed after the provided life time. See [Tome vs Debris](https://github.com/y29r/Tome/blob/main/README.md#tome-vs-debris) for more information.

Every method has an example of use case above it: [Tome-main](https://github.com/y29r/Tome/blob/main/Tome.luau)

## Example
Creating a Tome and adding things into it is very simple:
```luau
local newTome: Tome.Tome = Tome.new()

-- add something into the tome
newTome:Add(workspace.Part)

-- destroying the tome causes the part to be destroyed as well
newTome:Destroy()
```

## Metaprops
Metaprops are a way to tell Tome how to go about dealing with objects as a whole. This includes how to handle adding them, as well as destroying them, or something in between.

- Currently Tome has a few metaprops that help differently:
  - `FastAdd` : Whether to use fast adding when appending objects into a Tome. FastAdd will skip over many validity checks. If you still want to retain the benefits of a standard Add, you can use `Tome:FastAdd` which works similarly.
  - `SpawnDestroy` : This tells Tome that all the objects should be destroyed within a spawned thread. Essentially a wrapping for:
    ```luau
	local newTome: Tome.Tome = Tome.new()

    newTome:Add(workspace.Part, function(part: BasePart)
		task.spawn(function()
    		-- here you may have some yielding code that prevents other objects from being destroyed
			part:Destroy()
    	end)
    end)
    ```
    Though Tome optimizes it into a `task.spawn` call directly :)
    This is useful for when you want object destroy methods to not yield the main destroy thread which can cause serious issues if not used well.
  - `Warnings` : Whether warnings that aren't serious should be outputed.
  - `Tagging` : Whether Tome uses [Tagging](https://github.com/y29r/Tome/blob/main/README.md#tagging)
  - `UseParentMetaprops` : Whether any Pages should inherit the same metaprops as the parent.

## Tagging
Tagging uses [CollectionService](https://create.roblox.com/docs/reference/engine/classes/CollectionService) to track [Instance-based](https://create.roblox.com/docs/reference/engine/datatypes/Instance) objects. Tome will check if its internal tag has been removed from the object, if it has, that means the object was destroyed which will tell Tome to remove it from itself automatically.

## Performance
Performance is very similar to other garbage collection modules such as Janitor, Trove and Maid.
However in a lot of cases Tome outperformed them all due to manual destroy methods. e.g.
```luau
local newTome: Tome.Tome = Tome.new()

newTome:FastAdd(workspace.Part, "Destroy")
```
`Tome:FastAdd` skips over any checks, and the second argument `"Destroy"` will tell Tome how to clean up the given object.

As well as the fact Tome is entirely `O(1)` index time complexity. This means external object removal is faster (e.g. `Tome:Remove`) as well as any search queries.

> [!NOTE]
> Instiantiation is slightly slower than other libraries as Tome has to internally come up with metaprops. You can improve speeds by passing in some form of metaprops rather than letting Tome do it alone.

## Destroy Methods

Currently you can provide these as manual destroy methods:
- `"Destroy"`
- `"cancel"`
- `"Disconnect"`
- `string`
- `table.clear`
- `Tome.FunctionType`
- `Tome.ThreadType`
- `Tome.TweenType`
- `function`

Any string passed in will tell Tome to index the object with the string and then safely call the return value e.g.
```luau
local destroyFunction: ((object: any) -> ())? = object[destroyMethod]
if destroyFunction then
	pcall(destroyFunction, object)
end
```

If a function is passed, Tome will call it and pass the object in as the first argument of that function which allows you to make custom destroy functionality, such as a fade out animation:
```luau
scopeTome:Add(workspace.Part, function(part: BasePart)
	task.spawn(function()
		for index: number = 0, 1, 0.1 do
			part.Transparency = index
			
			task.wait(0.1)
		end

		part:Destroy()
	end)
end)
```

## Tome vs Debris
Debris is a Roblox-provided service that helps clean up `Instance`s over time. However [Debris](https://create.roblox.com/docs/reference/engine/classes/Debris) hasn't been updated in many years, and many view it as an outdated service (aka deprecated) But many also view it as a great way to clean up unused objects. Sadly, staff have [already mentioned](https://devforum.roblox.com/t/debris-maxitems-still-in-effect-despite-being-deprecated/2612863/3) that it may likely be officially deprecated.

So what's the solution? Tome offers a very similar implementation with `Tome.schedule`. And it works nearly identical to Debris, while being more performant too.

Though at the end of the day, what matters is that the garbage gets cleaned up.
