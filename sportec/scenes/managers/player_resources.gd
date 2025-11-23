class_name PlayerResources
extends Resource

@export var name : String
@export var skincolor : Player.SkinColor
@export var role : Player.Role
@export var speed : float
@export var power : float

func _init(p_name: String, p_skin: Player.SkinColor, p_role: Player.Role, p_speed: float, p_power: float) -> void:
	name = p_name
	skincolor = p_skin
	role = p_role
	speed = p_speed
	power = p_power
