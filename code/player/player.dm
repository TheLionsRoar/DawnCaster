mob
	bound_width = 48
	bound_height = 48
	var
		rotspeed = 4
		speed = 8
	Login()
		. = ..()
		src << sounds[MUSIC1]
		client.camera = new(client)
		client.camera.frame_update()
	actor
		player
			var
				alive = 1
				armor = 100
				ammo = 14
				clip = 7
				health = 100
				__hurttime
				reloading = 0
				list/weapons = list(new/weapon/fist(),new/weapon/pistol(),null)
				current_weapon = 2
				list/keys = list()
			proc
				die()
					alive = 0
					client.camera.hurt_cookie.invisibility = 0
					client.camera.tutorial.icon_state = "gameover"
				takeDamage(amt)
					set waitfor = 0
					var/time = world.time
					__hurttime = time
					if(src.armor)
						src.armor -= amt
						if(src.armor<0)
							src.armor = 0
						client.camera.setArmor(src.armor)
					else
						src.health -= amt
						if(src.health<=0)
							src.health = 0
							client.camera.setHealth(src.health)
							die()
							return
						client.camera.setHealth(src.health)
					client.camera.hurt_cookie.invisibility = 0
					sleep(TICK_LAG*2)
					if(__hurttime==time)
						client.camera.hurt_cookie.invisibility = 101

				fireGun()
					if(src.current_weapon>0)
						var/weapon/w = weapons[current_weapon]
						w.fire(src)
					else
						sleep(TICK_LAG)

				reloadGun()
					if(src.current_weapon>0)
						var/weapon/w = weapons[current_weapon]
						w.reload(src)

				switchWeapon(wnum)
					var/weapon/w = weapons[wnum]
					if(w&&wnum!=current_weapon)
						w.activate(src)