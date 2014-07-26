obj
	pickup
		icon = 'pickups.dmi'
		var
			stack = 0
		Crossed(atom/movable/o)
			if(istype(o,/mob/actor/player))
				Pickup(o)
				src.loc = null

		proc
			Pickup(mob/actor/player/player)

		ammo
			icon_state = "ammo"
			bound_x = 24
			bound_y = 24
			bound_width = 16
			bound_height = 16
			var
				weapon = 2
				sound = "pickup pistol ammo"

			Pickup(mob/actor/player/player)
				var/weapon/w = player.weapons[src.weapon]
				w.ammo += src.stack
				if(w.ammo>w.max_ammo)
					w.ammo = w.max_ammo
				if(src.weapon==player.current_weapon)
					player.client.camera.setAmmo(w.ammo)
				player << sounds[sound]

		healthpack
			icon_state = "medkit"
			bound_x = 24
			bound_y = 24
			bound_width = 16
			bound_height = 16
			stack = 25

			Pickup(mob/actor/player/player)
				player.health += src.stack
				if(player.health>100)
					player.health = 100
				player.client.camera.setHealth(player.health)
				player << sounds[PICKUP_HEALTHPACK]

		armor
			icon_state = "armor"
			bound_x = 24
			bound_y = 24
			bound_width = 16
			bound_height = 16
			stack = 25

			Pickup(mob/actor/player/player)
				player.armor += src.stack
				if(player.armor>100)
					player.armor = 100
				player.client.camera.setArmor(player.armor)
				player << sounds[PICKUP_ARMOR]

		key
			bound_x = 24
			bound_y = 24
			bound_width = 16
			bound_height = 16
			var
				keycode
			Pickup(mob/actor/player/player)
				if(!(keycode in player.keys))
					player.keys += keycode
					player.client.camera.tutorial.icon_state = "[keycode]key"
				player << sounds[PICKUP_KEY]

		mgun
			icon_state = "mgun"
			Pickup(mob/actor/player/player)
				player.weapons[3] = new/weapon/machine_gun()