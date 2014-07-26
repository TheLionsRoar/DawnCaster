weapon
	var
		max_ammo
		ammo
		clip
	proc
		fire(mob/actor/player/p)
		reload(mob/actor/player/p)
		activate(mob/actor/player/p)
	fist
		max_ammo = 0
		clip = 0
		activate(mob/actor/player/p)
			p.current_weapon = 0
			animate(p.client.camera.weapon_overlay,transform=matrix(1,0,322,0,1,302),time=4)
			animate(icon_state="4",transform=matrix(1,0,318,0,1,312),time=4)
			sleep(TICK_LAG*8)
			p.client.camera.ammo_hud.invisibility = 101
			p.client.camera.clip_hud.invisibility = 101
			sleep(TICK_LAG*8)
			p.current_weapon = 1

		fire(mob/actor/player/p)
			if(!p.reloading)
				animate(p.client.camera.weapon_overlay,transform = matrix(1,0,312,0,1,322),time=1)
				animate(transform=matrix(1,0,318,0,1,312),time=1)
				new/obj/bullet/playerbullet(p,p.ang,2)
			sleep(TICK_LAG*8)

		reload(mob/actor/player/p)
			return 0
	pistol
		max_ammo = 50
		ammo = 14
		clip = 7
		activate(mob/actor/player/p)
			p << sounds[PISTOL_RELOAD]
			p.current_weapon = 0
			animate(p.client.camera.weapon_overlay,transform = matrix(1,0,322,0,1,302),time=4)
			animate(icon_state="0",transform=matrix(1,0,312,0,1,322),time=2)
			sleep(TICK_LAG*8)
			p.client.camera.ammo_hud.invisibility = 0
			p.client.camera.clip_hud.invisibility = 0
			p.client.camera.ammo_hud.transform = matrix(1,0,386,0,1,322)
			p.client.camera.clip_hud.icon = 'ammohud.dmi'
			p.client.camera.clip_hud.transform = matrix(1,0,386,0,1,322)
			p.client.camera.setAmmo(src.ammo)
			p.client.camera.setClip(src.clip)
			sleep(TICK_LAG*4)
			p.current_weapon = 2
		fire(mob/actor/player/p)
			if(!p.reloading)
				if(clip)
					clip--
					p.client.camera.setClip(clip)
					p << sounds[PISTOL_SHOOT]
					animate(p.client.camera.weapon_overlay,icon_state = "1",transform = matrix(1,0,314,0,1,318),time=1)
					animate(icon_state = "0",transform = matrix(1,0,312,0,1,322),time=1)
					new/obj/bullet/playerbullet(p,p.ang,32)
			sleep(TICK_LAG*8)
		reload(mob/actor/player/p)
			if(!p.reloading)
				if(ammo>0&&clip<7)
					p << sounds[PISTOL_RELOAD]
					p.reloading = 1
					. = min(ammo,7-clip)
					ammo -= .
					clip += .
					p.client.camera.setAmmo(ammo)
					animate(p.client.camera.weapon_overlay,transform = matrix(1,0,322,0,1,302),time=4)
					animate(transform=matrix(1,0,312,0,1,322),time=4)
					sleep(TICK_LAG*16)
					p.client.camera.setClip(clip)
					p.reloading = 0
	machine_gun
		max_ammo = 200
		ammo = 60
		clip = 30
		activate(mob/actor/player/p)
			p << sounds[PISTOL_RELOAD]
			p.current_weapon = 0
			animate(p.client.camera.weapon_overlay,transform = matrix(1,0,322,0,1,302),time=4)
			animate(icon_state="2",transform=matrix(1,0,312,0,1,322),time=4)
			sleep(TICK_LAG*8)
			p.client.camera.ammo_hud.invisibility = 0
			p.client.camera.clip_hud.invisibility = 0
			p.client.camera.ammo_hud.transform = matrix(1,0,392,0,1,333)
			p.client.camera.clip_hud.icon = 'mgammohud.dmi'
			p.client.camera.clip_hud.transform = matrix(1,0,360,0,1,322)
			p.client.camera.setAmmo(src.ammo)
			p.client.camera.setClip(src.clip)
			sleep(TICK_LAG*8)
			p.current_weapon = 3
		fire(mob/actor/player/p)
			if(!p.reloading)
				if(clip)
					p.client.camera.setClip(--clip)
					p << sounds[MGUN_SHOOT]
					animate(p.client.camera.weapon_overlay,icon_state="3",transform = matrix(1,0,314,0,1,318),time=0.5)
					animate(icon_state = "2",transform = matrix(1,0,312,0,1,322),time=0.5)
					animate(icon_state = "3",transform = matrix(1,0,314,0,1,318),time=0.5)
					animate(icon_state = "2",transform = matrix(1,0,312,0,1,322),time=0.5)
					animate(icon_state = "3",transform = matrix(1,0,314,0,1,318),time=0.5)
					animate(icon_state = "2",transform = matrix(1,0,312,0,1,322),time=0.5)
					new/obj/bullet/playerbullet(p,p.ang,32)
					sleep(TICK_LAG*2)
					p.client.camera.setClip(--clip)
					p << sounds[MGUN_SHOOT]
					new/obj/bullet/playerbullet(p,p.ang+rand(-8,8),32)
					sleep(TICK_LAG*2)
					p.client.camera.setClip(--clip)
					p << sounds[MGUN_SHOOT]
					new/obj/bullet/playerbullet(p,p.ang+rand(-8,8),32)
			sleep(TICK_LAG*2)

		reload(mob/actor/player/p)
			if(!p.reloading)
				if(ammo>0&&clip<30)
					p << sounds[PISTOL_RELOAD]
					p.reloading = 1
					. = min(ammo,30-clip)
					ammo -= .
					clip += .
					p.client.camera.setAmmo(ammo)
					animate(p.client.camera.weapon_overlay,transform = matrix(1,0,322,0,1,302),time=4)
					animate(transform=matrix(1,0,312,0,1,322),time=4)
					sleep(TICK_LAG*16)
					p.client.camera.setClip(clip)
					p.reloading = 0