extends Area2D
signal hit

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var speed = 400
var screen_size

var velocity = Vector2()
var target = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	
	screen_size = get_viewport_rect().size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if position.distance_to(target) > 10:
		velocity = (target - position).normalized()
		$AnimatedSprite.play()
	else:
		velocity = Vector2()
		$AnimatedSprite.stop()
	
	position += velocity * speed * delta
	
	if velocity.x != 0:
		$AnimatedSprite.animation = "right"
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite.animation = "up"
		$AnimatedSprite.flip_v = velocity.y > 0

func _input(event):
	if event is InputEventScreenTouch and event.pressed:
		target = event.position

func _on_Player_body_entered(body):
	$CollisionShape2D.set_deferred("disabled", true)
	hide()
	emit_signal("hit")
	
func start(pos):
	position = pos
	target = pos
	show()
	$CollisionShape2D.disabled = false
