extends Node

enum gridSpace {
	emptySpace,
	floorSpace,
	wallSpace
}
var grid = []
export (Vector2) var levelSize = Vector2(30, 30)
export (int) var levelSizeRes = 1

class Walker:
	var pos: Vector2
	var dir: Vector2
	
var walkers = []

export (float) var chanceWalkerChangeDir = 0.5
export (float) var chanceDestroyWalker = 0.05
export (float) var chanceSpawnWalker = 0.05
export (int) var maxWalkers = 10
export (float) var targetGridFillPercent = 0.2

export (float) var spriteScale = 0.25
export (float) var spritePixelSize = 70

# Wall and Floor Objects
export (PackedScene) var floorObj
export (PackedScene) var wallObj

# Will be set in-code dynamically
var levelHeight : int
var levelWidth : int
var levelArea : int
var floorCount : int

func _ready():
	setup()
	createFloors()
	createWalls()
	populateEnv(2)
	
func setup():
	randomize()
	
	# Setup grid space
	levelWidth = levelSize.x / levelSizeRes	
	levelHeight = levelSize.y / levelSizeRes	
	setupGridSpace(levelWidth, levelHeight)
	levelArea = levelWidth * levelHeight
	
	# Setup walkers
	var walker = Walker.new()
	walker.dir = randDir()
	var walkerSpawnPos = Vector2(round(levelWidth/2), round(levelHeight/2)) 
	walker.pos = walkerSpawnPos
	walkers.append(walker)
	
func setupGridSpace(width, height):
	for x in range(width):
		grid.append([])
		for y in range(height):
			grid[x].append(gridSpace.emptySpace)
			
func randDir():
	var choice = randi() % 4
	match choice:
		0:
			return Vector2.DOWN
		1:
			return Vector2.LEFT
		2:
			return Vector2.UP
		_:
			return Vector2.RIGHT
			
func createFloors():
	var iter = 0
	while(iter==0 or iter<100000):
		
		# Set floor where walkers are
		for walker in walkers:
			grid[walker.pos.x][walker.pos.y] = gridSpace.floorSpace
			floorCount += 1
		
		# Destroy Walker?
		for	i in range(walkers.size()):
			if (randf() < chanceDestroyWalker and walkers.size() > 1):
				walkers.remove(i)
				break
		
		# Walker change direction?
		for	i in range(walkers.size()):
			if (randf() < chanceWalkerChangeDir):
				walkers[i].dir = randDir() # Could potentially pick the same dir
		
		# Spawn more walkers?
		for	i in range(walkers.size()):
			if (randf() < chanceSpawnWalker and walkers.size() < maxWalkers):
				var newWalker = Walker.new()
				newWalker.dir = randDir()
				newWalker.pos = walkers[i].pos
				walkers.append(newWalker)
		
		# Move walkers			
		for	i in range(walkers.size()):
			walkers[i].pos += walkers[i].dir
			walkers[i].pos.x = clamp(walkers[i].pos.x, 1, levelWidth - 2)
			walkers[i].pos.y = clamp(walkers[i].pos.y, 1, levelHeight - 2)
			
		if (floorCount / levelArea >= targetGridFillPercent):
			break;
				
		iter += 1
		
func createWalls():
	for x in range (levelWidth):
		for y in range (levelHeight):
			if (grid[x][y] == gridSpace.floorSpace):			
				if(grid[x][y+1] == gridSpace.emptySpace):
					grid[x][y+1] = gridSpace.wallSpace
				if(grid[x][y-1] == gridSpace.emptySpace):
					grid[x][y-1] = gridSpace.wallSpace
				if(grid[x+1][y] == gridSpace.emptySpace):
					grid[x+1][y] = gridSpace.wallSpace
				if(grid[x-1][y] == gridSpace.emptySpace):
					grid[x-1][y] = gridSpace.wallSpace
				
func spawn (x,y,obj:PackedScene):
	var instance = obj.instance()
	var offset = levelSize / 2
	var spawnPos = Vector2(x, y) * levelSizeRes - offset
	instance.scale.x = spriteScale
	instance.scale.y = spriteScale
	instance.position.x = x * (spritePixelSize * spriteScale)
	instance.position.y = y * (spritePixelSize * spriteScale)
	add_child(instance)
	
func populateEnv(offsetFromOrigin):
	for x in range (levelWidth):
		for y in range (levelHeight):
			match grid[x][y]:
				gridSpace.floorSpace:
					spawn(x + offsetFromOrigin, y + offsetFromOrigin, floorObj)
				gridSpace.wallSpace:	
					spawn(x + offsetFromOrigin, y + offsetFromOrigin, wallObj)

