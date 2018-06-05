extends KinematicBody2D

# This demo shows how to build a kinematic controller.

# Member variables
const GRAVITY = 500.0 # pixels/second/second

# Angle in degrees towards either side that the player can consider "floor"
const FLOOR_ANGLE_TOLERANCE = 40
const WALK_FORCE = 600
const WALK_MIN_SPEED = 10
const WALK_MAX_SPEED = 200
const STOP_FORCE = 1300
const JUMP_SPEED = 220
const JUMP_MAX_AIRBORNE_TIME = 0.2

const SLIDE_STOP_VELOCITY = 1.0 # one pixel/second
const SLIDE_STOP_MIN_TRAVEL = 1.0 # one pixel

var velocity = Vector2()
var on_air_time = 100
var jumping = false

var prev_jump_pressed = false

var anim_player = null
var anim = "StopDx"
var new_anim = ""

func _ready():
	anim_player = get_node("Sprite/AnimationPlayer")
	set_process_input(true)
	
#func _input(event):
	#if event is InputEventScreenTouch:
		#if event.is_pressed():
			#var screen_res = OS.get_window_size()
			#if event.position[0] < screen_res.x / 2:
				#get_node('.').hide()
			#if event.position[0] >= screen_res.x / 2:
				#get_node('.').show()


func _physics_process(delta):
	# Create forces
	var force = Vector2(0, GRAVITY)
	
	var walk_left = Input.is_action_pressed("ui_left")
	var walk_right = Input.is_action_pressed("ui_right")
	var jump = Input.is_action_pressed("ui_up")
	var down = Input.is_action_pressed("ui_down")
	var button_walk_jump = get_node("CanvasLayer/Up").is_pressed()
	var button_walk_right = get_node("CanvasLayer/DX").is_pressed()
	var button_walk_left = get_node("CanvasLayer/SX").is_pressed()
	
	var stop = true

	
	if new_anim != anim:
		new_anim = anim
		anim_player.play(anim)
	
	
	if (walk_left or button_walk_left) and down == false:
		if velocity.x <= WALK_MIN_SPEED and velocity.x > -WALK_MAX_SPEED:
			force.x -= WALK_FORCE
			stop = false
		if is_on_floor():
			anim = "WalkSx"
		else:
			anim = "JumpSx"
	
	elif (walk_left or button_walk_left)  and down:
			anim = "DownSx"

			
	elif (walk_right or button_walk_right) and down == false:
		if velocity.x >= -WALK_MIN_SPEED and velocity.x < WALK_MAX_SPEED:
			force.x += WALK_FORCE
			stop = false
		if is_on_floor():
			anim = "WalkDx"
		else:
			anim = "JumpDx"
			
	elif (walk_right or button_walk_right) and down:
			anim = "DownDx"
			
	elif down and (anim == "StopDx" or anim == "JumpDx"):
		anim = "DownDx"
	elif down and (anim == "StopSx" or anim == "JumpSx"):
		anim = "DownSx"
	else:
		if anim == "WalkDx" or (anim == "JumpDx" and is_on_floor()) or (anim == "DownDx" and down == false):
			anim = "StopDx"
			
		elif anim == "WalkSx" or (anim == "JumpSx" and is_on_floor()) or (anim == "DownSx" and down == false):
			anim = "StopSx"
			
		elif is_on_floor() == false:
			if anim == "StopDx":
				anim = "JumpDx"
				
			if anim == "StopSx":
				anim = "JumpSx"
		
		
	if stop:
		var vsign = sign(velocity.x)
		var vlen = abs(velocity.x)
		
		vlen -= STOP_FORCE * delta
		if vlen < 0:
			vlen = 0
		
		velocity.x = vlen * vsign
	
	# Integrate forces to velocity
	velocity += force * delta
	# Integrate velocity into motion and move
	velocity = move_and_slide(velocity, Vector2(0, -1))
	
	if down:
		velocity.y = JUMP_SPEED * 2
		
	if is_on_floor():
		on_air_time = 0
		
	if jumping and velocity.y > 0:
		# If falling, no longer jumping
		jumping = false

	
	if on_air_time < JUMP_MAX_AIRBORNE_TIME  and (jump or button_walk_jump) and not prev_jump_pressed and not jumping and not down:
		# Jump must also be allowed to happen if the character left the floor a little bit ago.
		# Makes controls more snappy.
		velocity.y = -JUMP_SPEED
		jumping = true
		
	
	on_air_time += delta
	prev_jump_pressed = jump


func _on_Star_body_entered(body):
	get_tree().change_scene("res://piccoloLuigi/Livelli/ProvaLiv.tscn")


func _on_Level1Block_body_entered(body):
	get_tree().change_scene("res://piccoloLuigi/Livelli/Livello1.tscn")
		
