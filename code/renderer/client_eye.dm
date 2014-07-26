client_eye
	var
		client/owner
		list/wall_objs = list()
		list/sprites = list()
		list/floor_objs = list()
		list/ceil_objs = list()
		obj/weapon_overlay
		obj/hurt_cookie
		obj/health_hud
		obj/armor_hud
		obj/ammo_hud
		obj/clip_hud
		obj/tutorial
		ambient_light = 10
		renderer/renderer = new()
	proc
		frame_update()
			set waitfor = 0
			while(1)
				renderer.render(src,src.owner.mob.x + (src.owner.mob.step_x + src.owner.mob.bound_width / 2) / TILE_WIDTH,src.owner.mob.y + (src.owner.mob.step_y + src.owner.mob.bound_height / 2) / TILE_HEIGHT,src.owner.mob.ang,src.owner.mob.z)
				sleep(TICK_LAG)

		setClip(amt)
			clip_hud.icon_state = "[amt]"

		setAmmo(amt)
			amt = "[amt]"
			var/pos = length(amt)
			var/obj/o = new()
			o.layer = FLOAT_LAYER
			ammo_hud.overlays.Cut(1,0)
			while(pos)
				o.icon_state = "[text2ascii(amt,pos--)-48]"
				o.pixel_x -= 4
				ammo_hud.overlays += o

		setArmor(amt)
			if(amt==0)
				armor_hud.invisibility = 101
			else
				armor_hud.invisibility = 0
				amt = "[amt]"
				var/pos = 1
				var/len = length(amt)
				var/obj/o = new()
				o.layer = FLOAT_LAYER
				o.pixel_x = 6
				armor_hud.overlays.Cut(1,0)
				while(pos<=len)
					o.icon_state = "[text2ascii(amt,pos++)-48]"
					armor_hud.overlays += o
					o.pixel_x += 4

		setHealth(amt)
			var/char
			if(amt>=75)
				char = "g"
			else if(amt<25)
				char = "r"
			else if(amt<50)
				char = "y"
			else
				char = ""
			amt = "[amt]"
			var/pos = 1
			var/len = length(amt)
			var/obj/o = new()
			o.layer = FLOAT_LAYER
			o.pixel_x = 7
			health_hud.overlays.Cut(1,0)
			while(pos<=len)
				o.icon_state = "[char][text2ascii(amt,pos++)-48]"
				health_hud.overlays += o
				o.pixel_x += 4

	New(client/c)
		owner = c
		var/obj/screen_obj/o
		for(var/count=1;count<=SCREEN_WIDTH;count++)
			o = new()
			o.screen_loc = "1,1"
			wall_objs += o
		var/col
		for(var/count=1;count<=SCREEN_HEIGHT/2;count++)
			o = new()
			o.icon = 'span.dmi'
			o.screen_loc = "1,1"
			o.layer = FLOOR_LAYER
			o.transform = matrix(1,0,312,0,1,count-1+322)
			col = floor(192 * (1 - clamp(count / (SCREEN_HEIGHT/2),0,1)))
			o.color = rgb(col,col,col)
			floor_objs += o
			o = new()
			o.icon = 'span.dmi'
			o.screen_loc = "1,1"
			o.layer = FLOOR_LAYER
			o.transform = matrix(1,0,312,0,1,SCREEN_HEIGHT-count+322)
			col = floor(96 * (1 - clamp(count / (SCREEN_HEIGHT/2),0,1)))
			o.color = rgb(col,col,col)
			ceil_objs += o
		var/obj/w
		w = new()
		w.icon = 'gun_overlay.dmi'
		w.screen_loc = "1,1"
		w.transform = matrix(1,0,312,0,1,322)
		w.icon_state = "0"
		w.layer = WEAPON_LAYER
		weapon_overlay = w
		w = new()
		w.icon = 'hurtcookie.dmi'
		w.screen_loc = "1,1"
		w.transform = matrix(1,0,312,0,1,322)
		w.invisibility = 101
		w.layer = WEAPON_LAYER+1
		hurt_cookie = w
		w = new()
		w.icon = 'numbers.dmi'
		w.icon_state = "health"
		w.screen_loc = "1,1"
		w.transform = matrix(1,0,313,0,1,375)
		w.layer = WEAPON_LAYER+2
		health_hud = w
		w = new()
		w.icon = 'numbers.dmi'
		w.icon_state = "armor"
		w.screen_loc = "1,1"
		w.transform = matrix(1,0,374,0,1,375)
		w.layer = WEAPON_LAYER+2
		armor_hud = w
		w = new()
		w.icon = 'numbers.dmi'
		w.screen_loc = "1,1"
		w.transform = matrix(1,0,386,0,1,322)
		w.layer = WEAPON_LAYER+2
		ammo_hud = w
		w = new()
		w.icon = 'ammohud.dmi'
		w.screen_loc = "1,1"
		w.transform = matrix(1,0,386,0,1,322)
		w.layer = WEAPON_LAYER+2
		clip_hud = w
		w = new()
		w.icon = 'tutorial.dmi'
		w.screen_loc = "1,1"
		w.transform = matrix(1,0,312,0,1,322)
		w.layer = WEAPON_LAYER+3
		tutorial = w
		setClip(7)
		setAmmo(14)
		setHealth(100)
		setArmor(100)
		owner.screen.Add(ceil_objs)
		owner.screen.Add(floor_objs)
		owner.screen.Add(wall_objs)
		owner.screen.Add(weapon_overlay,hurt_cookie,health_hud,armor_hud,ammo_hud,clip_hud,tutorial)