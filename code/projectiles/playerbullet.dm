obj
	bullet
		playerbullet
			hit()
				if(istype(hit,/mob/enemy))
					var/mob/enemy/e = hit
					src.icon = 'bullethit.dmi'
					src.icon_state = "2"
					e.shot(src)
				else if(istype(hit,/obj/eggclutch))
					var/obj/eggclutch/e = hit
					src.icon = 'bullethit.dmi'
					src.icon_state = "3"
					e.damaged(rand(25,40))
				else
					src.icon = 'bullethit.dmi'
					src.icon_state = "1"
				sleep(TICK_LAG*4)
				src.loc = null