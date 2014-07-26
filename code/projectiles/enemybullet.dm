obj
	bullet
		enemybullet
			hit()
				if(istype(hit,/mob/actor/player))
					var/mob/actor/player/p = hit
					p.takeDamage(15)
				sleep(TICK_LAG*4)
				src.loc = null

			spit
				icon = 'spit.dmi'