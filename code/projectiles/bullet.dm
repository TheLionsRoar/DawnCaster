obj
	bullet
		bound_width = 4
		bound_height = 4
		density = 1
		var
			atom/hit
		proc
			hit()
		New(mob/spawner,ang,lifetime=32)
			set waitfor = 0
			src.ang = ang
			src.loc = spawner.loc
			src.step_x = spawner.step_x + spawner.bound_width/2 - 2
			src.step_y = spawner.step_y + spawner.bound_height/2 - 2
			var/nx
			var/ny
			var/sx
			var/sy
			var/turf/t
			while(!hit && lifetime--)
				nx = x + step_x/TILE_WIDTH + cos(ang) / 64 * 16
				ny = y + step_y/TILE_HEIGHT + sin(ang) / 64 * 16
				t = locate(floor(nx),floor(ny),src.z)
				sx = floor((nx - floor(nx)) * TILE_WIDTH)
				sy = floor((ny - floor(ny)) * TILE_HEIGHT)
				src.Move(t,ang2dir(ang),sx,sy)
			src.density = 0
			if(hit)
				src.hit()
			else
				src.loc = null

		Bump(atom/movable/o)
			hit = o