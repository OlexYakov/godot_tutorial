extends YSort

export(int) var bats_to_spawn = 3

func _ready():
	var bats = get_children()
	for bat in bats:
		bat.connect("died",self,"bat_died_handler")

var deaths = 0
func bat_died_handler():
	deaths += 1
	if deaths >= bats_to_spawn:
		var bat_boss = get_node("BatBoss")
		if bat_boss != null:
			var pda = bat_boss.get_node("PlayerDetectionArea")
			pda.set_deferred("monitoring",true)
