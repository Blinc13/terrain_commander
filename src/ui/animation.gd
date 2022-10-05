extends Tween

class_name UiAnimations

# Funcs
func add_move(ui_el: Control, from: Vector2, to: Vector2, time: float):
	interpolate_property(ui_el, "rect_position", from, to, time, Tween.TRANS_QUINT, Tween.EASE_IN_OUT)

func change_places(ui_el_f: Control, ui_el_s: Control, time: float):
	var f_pos = ui_el_f.rect_position
	var s_pos = ui_el_s.rect_position
	
	add_move(ui_el_f, f_pos, s_pos, time)
	add_move(ui_el_s, s_pos, f_pos, time)
