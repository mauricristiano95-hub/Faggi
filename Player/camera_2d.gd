extends Camera2D

func _ready() -> void:
	if (
			get_node_or_null("../../Left_Bottom_Limit") != null and
			get_node_or_null("../../Right_Top_Limit") != null
		):
		var scene_left_limit = $"../../Left_Bottom_Limit".position
		var scene_right_limit = $"../../Right_Top_Limit".position
		limit_left = scene_left_limit.x
		limit_bottom = scene_left_limit.y
		limit_right = scene_right_limit.x
		limit_top = scene_right_limit.y
	else:
		push_warning("ATTENZIONE! I nodi Left_Bottom_Limit e
		 Right_Top_Limit sono mancanti. La camera potrebbe 
		non essere limitata correttamente sulla scena!")
