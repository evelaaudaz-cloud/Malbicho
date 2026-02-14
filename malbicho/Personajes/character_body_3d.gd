extends CharacterBody3D

# --- CONFIGURACIÓN ---
var speed = 5.0
var rotation_speed = 10.0 
var camera_speed = 2.0   

@onready var spring_arm = $SpringArm3D
@onready var visuals = $Visuals 
@onready var anim = $AnimationPlayer 

var cam_rot_h: float = 0.0
var cam_rot_v: float = 0.0

func _physics_process(delta: float):
	# 1. ROTACIÓN DE LA CÁMARA (FLECHAS)
	var input_cam_h = Input.get_axis("camara_der", "camara_izq")
	var input_cam_v = Input.get_axis("camara_abajo", "camara_arriba")
	
	cam_rot_h += input_cam_h * camera_speed * delta
	cam_rot_v += input_cam_v * camera_speed * delta
	cam_rot_v = clamp(cam_rot_v, -1.2, 0.4)
	
	spring_arm.rotation.y = cam_rot_h
	spring_arm.rotation.x = cam_rot_v

	# 2. MOVIMIENTO (WASD)
	var input_dir = Input.get_vector("mover_izquierda", "mover_derecha", "mover_adelante", "mover_atras")
	
	var forward = spring_arm.global_transform.basis.z
	var right = spring_arm.global_transform.basis.x
	
	forward.y = 0
	right.y = 0
	forward = forward.normalized()
	right = right.normalized()

	var direction = (forward * input_dir.y + right * input_dir.x).normalized()

	# --- LÓGICA DE MOVIMIENTO Y ANIMACIÓN ---
	if direction.length() > 0.1:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		
		# Rotación visual
		var target_angle = atan2(-direction.x, -direction.z)
		visuals.rotation.y = lerp_angle(visuals.rotation.y, target_angle, rotation_speed * delta)
		
		# ¡A CAMINAR!
		gestionar_animacion("Caminar")
	else:
		# Frenado suave
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
		
		# ¡A QUEDARSE QUIETO!
		# Si tienes una animación de Franz respirando o moviendo antenas, úsala aquí.
		# Si no tienes, usa "stop()" para que se congele.
		if anim.has_animation("Idle"):
			gestionar_animacion("Idle")
		else:
			anim.stop() 

	move_and_slide()

# Función para evitar que la animación se reinicie cada milisegundo
func gestionar_animacion(nombre: String):
	if anim.current_animation != nombre:
		anim.play(nombre)
