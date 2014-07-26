turf
	door
		var
			lock = null
		Enter(atom/movable/o)
			if(src.density)
				if(istype(o,/mob/actor/player))
					var/mob/actor/player/p = o
					if(src.lock==null)
						src.density = 0
						src.opacity = 0
						src.icon = null
						o << sounds[DOOR_OPEN]
					else if(src.lock in p.keys)
						src.density = 0
						src.opacity = 0
						src.icon = null
						o << sounds[DOOR_OPEN]
					else
						return ..()
					return 0
				else
					return ..()
			else
				return ..()