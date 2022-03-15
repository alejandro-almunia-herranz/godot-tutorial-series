extends KinematicBody2D

# Esta constante la usamos para multiplicar por el movimiento
# Prueba a quitarla de la multiplicación de la función
# move_and_collide() y verás que se mueve demasiado lentamente
const MAX_SPEED = 100

# Esta constante nos permite acelerar el movimiento del personaje
const ACCELERATION = 500

const FRICTION = 500

var velocity = Vector2.ZERO

# Al usar onready var nos quitamos el método _ready()
onready var animationPlayer = $AnimationPlayer

onready var animationTree = $AnimationTree

onready var animationState = animationTree.get("parameters/playback")


# Esta es la función que realmente utiliza, a partir del minuto 27 del vídeo
func _physics_process(delta):
	var input_vector = Vector2.ZERO
	# Obtenemos el movimiento en un vector (x, y) basándonos en como el usuario interacciona con las teclas de flecha
	# Como ventaja, permite el movimiento diagonal sin problemas
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	# Tenemos que normalizar el vector
	# VED EL QUAKE ORIGINAL Y EL PROBLEMA QUE TENÍA CON ESTO.... LOOOOOL
	input_vector = input_vector.normalized()
	
	# Si tenemos algo en el vector de entrada
	# Es decir, si han pulsado las teclas de movimiento
	if input_vector != Vector2.ZERO:
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	# Ahora usamos move_and_slide
	# IMPORTANTE: NO USAMOS DELTA, ESTA FUNCIÓN YA LO HACE SOLO
	velocity = move_and_slide(velocity)
