extends Panel

var time: float = 10.0

var seconds: int = 0
var msec: int = 0

func _process(delta):
	time -= delta
	msec = fmod(time,1)*100
	seconds = fmod(time,60)
	$Seconds.text = "%02d." % seconds
	$Milliseconds.text = "%03d" % msec
	
func stop() -> void:
	set_process(false)
	
func get_time_formatted() -> String:
	return "%02d.%03d" % [seconds, msec]
