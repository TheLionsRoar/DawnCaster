renderer
	var
		list/__tiles
		__planeX
		__planeY
		__x
		__cameraX
		__rayPosX
		__rayPosY
		__rayDirX
		__rayDirY
		__mapX
		__mapY
		__deltaDistX
		__deltaDistY
		__hit
		__sideDistX
		__sideDistY
		__stepX
		__stepY
		__perpWallDist
		__side
		obj/screen_obj/__o
		turf/__t
		__color
		__wallX
		__texX
		__lineHeight
		__spriteCount
		__spriteX
		__spriteY
		__tX
		__tY
		__invDet
		__spriteScreenX
		__spriteScreenY
		__spriteDist
		__spriteSize

	proc
		render(client_eye/c,posX,posY,ang,z)
			__tiles = list()
			__planeX = cos(ang-90) * 0.66
			__planeY = sin(ang-90) * 0.66
			for(__x=0;__x<SCREEN_WIDTH;__x++)
				__cameraX = 2 * __x / SCREEN_WIDTH - 1
				__rayPosX = posX
				__rayPosY = posY
				__rayDirX = cos(ang) + __planeX * __cameraX
				__rayDirY = sin(ang) + __planeY * __cameraX
				if(__rayDirX>=0&&__rayDirX<0.001) __rayDirX = 0.001
				else if(__rayDirX<=0&&__rayDirX>-0.001) __rayDirX = -0.001
				if(__rayDirY>=0&&__rayDirY<0.001) __rayDirY = 0.001
				else if(__rayDirY<=0&&__rayDirY>-0.001) __rayDirY = -0.001

				__mapX = floor(__rayPosX)
				__mapY = floor(__rayPosY)

				__deltaDistX = sqrt(1 + (__rayDirY * __rayDirY) / (__rayDirX * __rayDirX))
				__deltaDistY = sqrt(1 + (__rayDirX * __rayDirX) / (__rayDirY * __rayDirY))

				__hit = 0

				if(__rayDirX<0)
					__stepX = -1
					__sideDistX = (__rayPosX - __mapX) * __deltaDistX
				else
					__stepX = 1
					__sideDistX = (__mapX + 1 - __rayPosX) * __deltaDistX
				if(__rayDirY<0)
					__stepY = -1
					__sideDistY = (__rayPosY - __mapY) * __deltaDistY
				else
					__stepY = 1
					__sideDistY = (__mapY + 1 - __rayPosY) * __deltaDistY

				while(!__hit)
					if(__sideDistX < __sideDistY)
						__sideDistX += __deltaDistX
						__mapX += __stepX
						__perpWallDist = abs((__mapX - __rayPosX + (1 - __stepX) / 2) / __rayDirX)
						__side = 0
					else
						__sideDistY += __deltaDistY
						__mapY += __stepY
						__perpWallDist = abs((__mapY - __rayPosY + (1 - __stepY) / 2) / __rayDirY)
						__side = 1

					if(__perpWallDist>=c.ambient_light)
						__hit = 1
						break

					__t = locate(__mapX,__mapY,z)
					__tiles[__t] = 1
					if(__t.density)
						__hit = 1

				if(__side==0)
					__color = 255
					__wallX = __rayPosY + ((__mapX - __rayPosX + (1-__stepX) / 2) / __rayDirX) * __rayDirY
					__wallX -= floor(__wallX)
					__texX = floor(__wallX * TEXTURE_WIDTH)
					if(__rayDirX > 0)
						__texX = TEXTURE_WIDTH - __texX - 1
				else
					__color = 192
					__wallX = __rayPosX + ((__mapY - __rayPosY + (1-__stepY) / 2) / __rayDirY) * __rayDirX
					__wallX -= floor(__wallX)
					__texX = floor(__wallX * TEXTURE_WIDTH)
					if(__rayDirY < 0)
						__texX = TEXTURE_WIDTH - __texX - 1

				if(__perpWallDist>=0&&__perpWallDist<0.001) __perpWallDist = 0.001
				else if(__perpWallDist<=0&&__perpWallDist>-0.001) __perpWallDist = -0.001
				__lineHeight = abs(floor(SCREEN_HEIGHT / __perpWallDist)) / TEXTURE_HEIGHT

				__color = floor(__color * (1 - clamp(__perpWallDist / c.ambient_light,0,1)))

				__o = c.wall_objs[__x+1]
				__o.proxy = __t
				__o.icon = __t.icon
				__o.icon_state = "[__texX+1]"
				__o.layer = WALL_LAYER - max(1,__perpWallDist*10 / c.ambient_light)
				__o.color = rgb(__color,__color,__color)
				if(__color==0)
					__o.invisibility = 101
				else
					__o.invisibility = 0
					__o.transform = matrix(1,0,__x+312,0,__lineHeight,322)

				__spriteCount = 1
				for(var/turf/t in __tiles)
					for(var/atom/movable/o in t)
						__spriteX = (o.x + (o.step_x + o.bound_x + o.bound_width/2) / TILE_WIDTH) - posX
						__spriteY = (o.y + (o.step_y + o.bound_y + o.bound_height/2) / TILE_HEIGHT) - posY
						__invDet = 1 / (__planeX * sin(ang) - cos(ang) * __planeY)
						__tX = __invDet * (sin(ang) * __spriteX - cos(ang) * __spriteY)
						__tY = __invDet * (-__planeY * __spriteX + __planeX * __spriteY)
						if(__tX==0)
							__tX = 0.001
						if(__tY<=0)
							continue
						__spriteDist = __tY / SCREEN_HEIGHT / 2
						__spriteSize = abs(floor(SCREEN_HEIGHT / __tY)) / TEXTURE_HEIGHT
						__spriteScreenX = (__spriteSize * o.bound_width/2) + (-__spriteSize/2*TEXTURE_WIDTH) + floor(SCREEN_WIDTH / 2 * (1 + __tX / __tY))
						__spriteScreenY = abs(floor(SCREEN_HEIGHT * __tY)) / 2 + SCREEN_HEIGHT/2
						if(c.sprites.len<__spriteCount)
							__o = new/obj/screen_obj()
							__o.screen_loc = "1,1"
							c.sprites += __o
							c.owner.screen += __o
							__spriteCount++
						else
							__o = c.sprites[__spriteCount++]
						__o.icon = o.icon
						__o.icon_state = o.icon_state
						__o.proxy = o
						__o.layer = WALL_LAYER - max(1,__tY*10 / c.ambient_light)
						__color = floor(255 * (1 - clamp(__tY / c.ambient_light,0,1)))
						__o.color = rgb(__color,__color,__color)
						__o.transform = matrix(__spriteSize,0,__spriteScreenX+288,0,__spriteSize,322)

				while(__spriteCount<=c.sprites.len)
					__o = c.sprites[__spriteCount++]
					c.owner.screen -= __o
					c.sprites -= __o