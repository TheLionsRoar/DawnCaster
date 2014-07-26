mob/enemy
	var
		alive = 1
		mob/actor/target
		health = 100
		deathsound = MONSTER_DIE1
		attacksound = MONSTER_ATTACK1
	proc
		die()
			src.density = 0
			src.icon_state = "dead"
			src.alive = 0
			var/px
			var/py
			var/sy = src.y + (src.step_y + src.bound_height/2) / TILE_WIDTH
			var/sx = src.x + (src.step_x + src.bound_width/2) / TILE_HEIGHT
			var/d
			for(var/mob/actor/player/p in range(5,src))
				px = p.x + (p.step_x + p.bound_width/2) / TILE_WIDTH
				py = p.y + (p.step_y + p.bound_height/2) / TILE_HEIGHT
				d = sqrt((px - sx) ** 2 + (py-sy) ** 2)
				var/sound/s = sounds[src.deathsound]
				s.volume = (1 - (d/320 * d/320)) * 50
				p << s
			spawn(rand(300,600))
				respawn()
		respawn()
			for(var/obj/eggclutch/e in view(src,5))
				if(e.health)
					var/mob/enemy/baby/b = new/mob/enemy/baby()
					b.loc = e.loc
					spawn(rand(300,600))
						b.grow()
					break
			src.loc = null
		shot()
			src.health -= rand(25,40)
			if(src.health<=0)
				die()

		attack()
			var/mob/actor/player/player = target
			player.takeDamage(10)
			src.icon_state = "attack"
			var/px
			var/py
			var/sy = src.y + (src.step_y + src.bound_height/2) / TILE_WIDTH
			var/sx = src.x + (src.step_x + src.bound_width/2) / TILE_HEIGHT
			var/d
			for(var/mob/actor/player/p in range(5,src))
				px = p.x + (p.step_x + p.bound_width/2) / TILE_WIDTH
				py = p.y + (p.step_y + p.bound_height/2) / TILE_HEIGHT
				d = sqrt((px - sx) ** 2 + (py-sy) ** 2)
				var/sound/s = sounds[src.attacksound]
				s.volume = (1 - (d/320 * d/320)) * 100
				p << s
			sleep(TICK_LAG*4)
			if(src.alive)
				src.icon_state = ""
				sleep(TICK_LAG*8)

		AILoop()
			set waitfor = 0
			var/px
			var/py
			var/sx
			var/sy
			var/nx
			var/ny
			var/turf/t
			while(src.alive)
				if(!target)
					target = locate(/mob/actor/player) in view(5,src)
				else
					if(get_dist(target,src)>7)
						target = null
				if(target)
					if(bounds_dist(src,target)>0)
						px = target.x + target.step_x / TILE_WIDTH
						py = target.y + target.step_y / TILE_HEIGHT
						sx = x + step_x / TILE_WIDTH
						sy = y + step_y / TILE_HEIGHT
						ang = atan2(px-sx,py-sy)
						nx = sx + sin(ang) / 64 * speed
						ny = sy + cos(ang) / 64 * speed
						t = locate(floor(nx),floor(ny),src.z)
						sx = floor((nx - floor(nx)) * TILE_WIDTH)
						sy = floor((ny - floor(ny)) * TILE_HEIGHT)
						src.Move(t,ang2dir(ang),sx,sy)
						sleep(TICK_LAG)
					else
						attack()
				else
					sleep(rand(10,40) * TICK_LAG)
	New()
		. = ..()
		src.AILoop()

	Cross(atom/movable/o)
		if(istype(o,/obj/bullet/enemybullet))
			return 1
		else if(istype(o,/mob/enemy))
			return 1
		else
			return ..()

	slicer
		icon = 'enemy.dmi'
		deathsound = MONSTER_DIE1
		attacksound = MONSTER_ATTACK1
	spitter
		icon = 'enemy2.dmi'
		deathsound = MONSTER_DIE2
		attacksound = MONSTER_ATTACK2
		attack()
			src.icon_state = "attack"
			var/px
			var/py
			var/sy = src.y + (src.step_y + src.bound_height/2) / TILE_WIDTH
			var/sx = src.x + (src.step_x + src.bound_width/2) / TILE_HEIGHT
			var/d
			for(var/mob/actor/player/p in range(5,src))
				px = p.x + (p.step_x + p.bound_width/2) / TILE_WIDTH
				py = p.y + (p.step_y + p.bound_height/2) / TILE_HEIGHT
				d = sqrt((px - sx) ** 2 + (py-sy) ** 2)
				var/sound/s = sounds[src.attacksound]
				s.volume = (1 - (d/320 * d/320)) * 100
				p << s
			new/obj/bullet/enemybullet/spit(src,src.ang,16)
			sleep(TICK_LAG*4)
			if(src.alive)
				src.icon_state = ""
				sleep(TICK_LAG*40)
		AILoop()
			set waitfor = 0
			var/px
			var/py
			var/sx
			var/sy
			var/nx
			var/ny
			var/turf/t
			while(src.alive)
				if(!target)
					target = locate(/mob/actor/player) in view(5,src)
				else
					if(get_dist(target,src)>10)
						target = null
				if(target)
					if(bounds_dist(src,target)>=128)
						px = target.x + target.step_x / TILE_WIDTH
						py = target.y + target.step_y / TILE_HEIGHT
						sx = x + step_x / TILE_WIDTH
						sy = y + step_y / TILE_HEIGHT
						ang = atan2(px-sx,py-sy)
						nx = sx + sin(ang) / 64 * speed
						ny = sy + cos(ang) / 64 * speed
						t = locate(floor(nx),floor(ny),src.z)
						sx = floor((nx - floor(nx)) * TILE_WIDTH)
						sy = floor((ny - floor(ny)) * TILE_HEIGHT)
						src.Move(t,ang2dir(ang),sx,sy)
						sleep(TICK_LAG)
					else
						px = target.x + (target.step_x + target.bound_width/2) / TILE_WIDTH
						py = target.y + (target.step_y + target.bound_height/2) / TILE_HEIGHT
						sx = x + step_x / TILE_WIDTH
						sy = y + step_y / TILE_HEIGHT
						ang = atan2(px-sx,py-sy)
						attack()
				else
					sleep(rand(10,40) * TICK_LAG)
	tick
		icon = 'enemy4.dmi'
		speed = 4
		deathsound = MONSTER_DIE4
		attacksound = MONSTER_ATTACK3
		attack()
			var/mob/actor/player/player = target
			player.takeDamage(5)
			if(rand(1,100)>67)
				var/mob/enemy/baby/b = new/mob/enemy/baby()
				b.loc = src.loc
				spawn(rand(300,600))
					b.grow()
			src.icon_state = "attack"
			var/px
			var/py
			var/sy = src.y + (src.step_y + src.bound_height/2) / TILE_WIDTH
			var/sx = src.x + (src.step_x + src.bound_width/2) / TILE_HEIGHT
			var/d
			for(var/mob/actor/player/p in range(5,src))
				px = p.x + (p.step_x + p.bound_width/2) / TILE_WIDTH
				py = p.y + (p.step_y + p.bound_height/2) / TILE_HEIGHT
				d = sqrt((px - sx) ** 2 + (py-sy) ** 2)
				var/sound/s = sounds[src.attacksound]
				s.volume = (1 - (d/320 * d/320)) * 100
				p << s
			sleep(TICK_LAG*4)
			if(src.alive)
				src.icon_state = ""
				sleep(TICK_LAG*24)
	baby
		icon = 'enemy3.dmi'
		speed = 4
		bound_width = 16
		bound_height = 16
		deathsound = MONSTER_DIE4
		proc
			grow()
				if(src.alive)
					switch(rand(1,3))
						if(1,2)
							var/mob/enemy/e = new/mob/enemy/slicer()
							e.loc = src.loc
						else
							var/mob/enemy/e = new/mob/enemy/spitter()
							e.loc = src.loc
					src.loc = null
					src.alive = 0

		Cross(atom/movable/o)
			return 1

		Crossed(atom/movable/o)
			if(istype(o,/mob/actor/player)&&src.alive)
				src.health = 0
				die()

		AILoop()
			set waitfor = 0
			var/px
			var/py
			var/sx
			var/sy
			var/nx
			var/ny
			var/turf/t
			while(src.alive)
				if(!target)
					target = locate(/mob/actor/player) in view(5,src)
				else
					if(get_dist(target,src)>7)
						target = null
				if(target)
					if(bounds_dist(src,target)<128)
						px = target.x + target.step_x / TILE_WIDTH
						py = target.y + target.step_y / TILE_HEIGHT
						sx = x + step_x / TILE_WIDTH
						sy = y + step_y / TILE_HEIGHT
						ang = atan2(px-sx,py-sy)
						nx = sx + sin(ang-180) / 64 * speed
						ny = sy + cos(ang-180) / 64 * speed
						t = locate(floor(nx),floor(ny),src.z)
						sx = floor((nx - floor(nx)) * TILE_WIDTH)
						sy = floor((ny - floor(ny)) * TILE_HEIGHT)
						src.Move(t,ang2dir(ang-180),sx,sy)
						sleep(TICK_LAG)
					else
						sleep(TICK_LAG)
				else
					sleep(rand(10,40) * TICK_LAG)

obj
	eggclutch
		icon = 'eggclutch.dmi'
		var
			health = 50
		proc
			damaged(amt)
				src.health -= amt
				if(src.health<0)
					src.health = 0
				if(src.health<=0)
					src.icon_state = "broken"
		Cross(atom/movable/o)
			if(istype(o,/obj/bullet/playerbullet))
				if(src.health>0)
					o.Bump(src)
					return 0
				else
					return ..()
			else
				return ..()