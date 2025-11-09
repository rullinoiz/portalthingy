class_name NewGridMap extends GridMap

@export var exit: Exit
@export var spawn: Spawn

var size: Vector3i

var smallestX: int = 1000
var smallestY: int = 1000
var smallestZ: int = 1000

func get_slice(slice: Vector3i) -> Array[Array]:
	var objects: Array[Array]
	if slice.x == 1 or slice.x == -1: # objects[y][z]
		for y in range(size.y):
			var array = []
			array.resize(size.z)
			objects.append(array)
	elif slice.y == 1 or slice.y == -1: # objects[x][z]
		for x in range(size.x):
			var array = []
			array.resize(size.z)
			objects.append(array)
	elif slice.z == 1 or slice.z == -1: # objects[y][x]
		for y in range(size.y):
			var array = []
			array.resize(size.x)
			objects.append(array)
		
	for v: Vector3i in get_used_cells():
		var normalized := Vector3i(size.x - v.x + smallestX - 1, size.y - v.y + smallestY - 1, size.z - v.z + smallestZ - 1)
		if slice.x == 1 or slice.x == -1: 
			var currentRow = objects[normalized.y]
			var current: Variant = currentRow.get(normalized.z)
			
			if slice.x == 1 and ((not current) or current.x < v.x):
				currentRow[normalized.z] = v
			elif slice.x == -1 and ((not current) or current.x > v.x):
				currentRow[size.z - normalized.z - 1] = v
		elif slice.y == 1 or slice.y == -1:
			var currentRow = objects[normalized.x]
			var current: Variant = currentRow.get(normalized.z)
			
			if slice.y == 1 and ((not current) or current.y < v.y):
				currentRow[normalized.z] = v
			elif slice.y == -1 and ((not current) or current.y > v.y):
				currentRow[size.z - normalized.z - 1] = v
		elif slice.z == 1 or slice.z == -1:
			var currentRow = objects[normalized.y]
			var current: Variant = currentRow.get(normalized.x)
			
			if slice.z == 1 and ((not current) or current.z < v.z):
				currentRow[normalized.x] = v
			elif slice.z == -1 and ((not current) or current.z > v.z):
				currentRow[size.x - normalized.x - 1] = v
	
	return objects

func get_mesh(vector: Vector3i) -> Mesh:
	var id := get_cell_item(vector)
	var mesh := mesh_library.get_item_mesh(id)
	
	return mesh

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var largestX: int = -1000
	var largestY: int = -1000
	var largestZ: int = -1000
	
	for v: Vector3i in get_used_cells():
		if v.x > largestX:
			largestX = v.x
		elif v.x < smallestX:
			smallestX = v.x
		
		if v.y > largestY:
			largestY = v.y
		elif v.y < smallestY:
			smallestY = v.y
		
		if v.z > largestZ:
			largestZ = v.z
		elif v.z < smallestZ:
			smallestZ = v.z
	
	size = Vector3i(largestX - smallestX + 1, largestY - smallestY + 1, largestZ - smallestZ + 1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
