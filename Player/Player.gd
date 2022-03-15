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

# Esta función se llama cuando el nodo y sus hijos están listos para ser usados
""" func _ready():
	# Lo tenemos que meter aquí porque no está inicializado en el contructor
	animationPlayer = $AnimationPlayer """

# Esta función se llama n veces por segundo (frames por segundo)
# Este es el código que luego borra, lo dejo para referencia
""" func _physics_process(delta):
	# Si el botón predeterminado por la constante ui_right está pulsado	
	if Input.is_action_pressed("ui_right"):
		# Entonces ejecuta ese código
		print("Has pulsado la tecla flecha derecha")
		# Esto agrega 4 píxeles a la derecha a la posición en el eje horizontal del jugador
		velocity.x += 1
	# Si por contra el botón es izquierda
	elif Input.is_action_pressed("ui_left"):
		# Menos 4 píxeles al horizontal
		velocity.x -= 1
	# Si pulsamos tecla arriba
	elif Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	# si pulsamos tecla abajo
	elif Input.is_action_pressed("ui_down"):
		velocity.y += 1
	# Y si no estamos pulsando ninguna, que se quede quieto
	else:
		velocity.x = 0git remote add origin https://github.com/alejandro-almunia-herranz/godot-tutorial-series.git
		velocity.y = 0
		
	# Esto hace que el sprite se mueva Y COLISIONE con lo que sea que tenga colisión definida
	move_and_collide(velocity) """
	
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
		if input_vector.x > 0:
			animationPlayer.play("RunRight")
		else:
			animationPlayer.play("RunLeft")
			
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		# Si no hay nada pulsado, deceleramos
		animationPlayer.play("IdleRight")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	# Ahora usamos move_and_slide
	# IMPORTANTE: NO USAMOS DELTA, ESTA FUNCIÓN YA LO HACE SOLO
	velocity = move_and_slide(velocity)

# Esta función se llama en cada frame. El argumento delta indica
# el número de segundos que han pasado desde el último frame.
# En el caso de 60 FPS, delta vale 0.0166666
func _process(delta):
	pass
