extends PointLight2D

@onready var rand = RandomNumberGenerator.new()
const MIN_VAL = .7
const VAL_INTERVAL = .005
const MAX_VAL = .9
var val 
var reverse = false
# Called when the node enters the scene tree for the first time.
func _ready():
	val = rand.randf_range(MIN_VAL, MAX_VAL)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if val > MAX_VAL:
		reverse = true

	if reverse:
		if val <= MIN_VAL:
			reverse = false
		else:
			val -= VAL_INTERVAL
	
	else:
		val += VAL_INTERVAL
	
	self.color = Color(color.r, color.g, color.b, val)
