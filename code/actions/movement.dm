mob
	var
		__sliding = 0
	Move(atom/newloc,Dir=0,step_x=0,step_y=0)
		. = ..()
		if(src.loc && !. && !__sliding)
			__sliding = 1
			var/nx = newloc.x + step_x/TILE_WIDTH
			var/ny = newloc.y + step_y/TILE_HEIGHT
			var/px = src.x  + src.step_x / TILE_WIDTH
			var/py = src.y + src.step_y / TILE_HEIGHT
			if(nx<px)
				. = step(src,WEST,(px - nx) * TILE_WIDTH)
			else if(nx>px)
				. = step(src,EAST,(nx - px) * TILE_WIDTH)
			if(ny<py)
				. = step(src,SOUTH,(py - ny) * TILE_HEIGHT)
			else if(ny>py)
				. = step(src,NORTH,(ny - py) * TILE_HEIGHT)
			__sliding = 0

action
	idle
		id = "idle"
		var
			icon_state = "walk0"
			list/tap_actions = list("walk")

		Begin(mob/actor/actor)
			var/starttime = world.time
			..()
			if(actor.action!=src || actor.action_start!=starttime)
				return
			actor.icon_state = src.icon_state

		onKeyPressed(movekeyevent/e)
			var/mob/actor/player/p = e.owner.mob
			if(!p.alive)
				return
			//if tap_actions list is initialized, this idle state allows the player to move.
			if(tap_actions && tap_actions.len)
				//support only the specified tap actions
				if(e.taps > tap_actions.len)
					e.taps = tap_actions.len
				//reference the actor and specified action
				var/mob/actor/at = e.owner.mob
				var/action/ac = actions[tap_actions[e.taps]]
				//ensure that there is an action bound to this number of taps.
				if(ac!=null)
					var/list/l = list("state"=0,"count"=0)
					//attempt to call the action
					while(!at.Act(ac,l))
						sleep(TICK_LAG)
						if(!e.current)
							return

	walk
		id = "walk"

		Begin(mob/actor/actor)
			var/starttime = world.time
			..()
			if(actor.action!=src || actor.action_start !=starttime)
				return

			if(actor.client)
				var/mob/actor/player/p = actor
				var/client/c = actor.client
				var/nx
				var/ny
				var/turf/t
				var/sx
				var/sy

				while(actor.action==src && actor.action_start==starttime)
					if(c.move_dir==0&&c.analog_dir==0 || p.alive==0)
						actor.Idle()
						return

					if(c.analog_dir&WEST)
						actor.ang += actor.rotspeed
						if(actor.ang>360)
							actor.ang -= 360
					else if(c.analog_dir&EAST)
						actor.ang -= actor.rotspeed
						if(actor.ang<0)
							actor.ang += 360
					if(c.move_dir)
						if(c.move_dir&NORTH)
							. = actor.ang
							nx = actor.x + actor.step_x/TILE_WIDTH + cos(.) / 64 * actor.speed
							ny = actor.y + actor.step_y/TILE_HEIGHT + sin(.) / 64 * actor.speed
						else if(c.move_dir&SOUTH)
							. = actor.ang-180
							nx = actor.x + actor.step_x/TILE_WIDTH + cos(.) / 64 * actor.speed
							ny = actor.y + actor.step_y/TILE_HEIGHT + sin(.) / 64 * actor.speed
						if(c.move_dir&WEST)
							. = actor.ang+90
							nx = actor.x + actor.step_x/TILE_WIDTH + cos(.) / 64 * actor.speed
							ny = actor.y + actor.step_y/TILE_HEIGHT + sin(.) / 64 * actor.speed
						else if(c.move_dir&EAST)
							. = actor.ang-90
							nx = actor.x + actor.step_x/TILE_WIDTH + cos(.) / 64 * actor.speed
							ny = actor.y + actor.step_y/TILE_HEIGHT + sin(.) / 64 * actor.speed
						t = locate(floor(nx),floor(ny),actor.z)
						sx = floor((nx - floor(nx)) * TILE_WIDTH)
						sy = floor((ny - floor(ny)) * TILE_HEIGHT)
						actor.Move(t,ang2dir(.),sx,sy)
					sleep(TICK_LAG)