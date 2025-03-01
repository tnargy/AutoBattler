extends Node

func play(audio: AudioStream, single=false):
	if not audio:
		return
	if single:
		stop()
	for player: AudioStreamPlayer in get_children():
		if not player.playing:
			player.stream = audio
			player.play()
			return


func stop():
	for player: AudioStreamPlayer in get_children():
		player.stop()
