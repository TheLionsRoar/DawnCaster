world
	fps = 20
	icon_size = 64
	mob = /mob/actor/player
	view = 5

client
	var
		client_eye/camera

atom
	movable
		var
			ang = 0

obj
	screen_obj
		var
			atom/proxy
		Click(location,control,params)
			if(src.proxy)
				src.proxy.Click(location,control,params)

#define SCREEN_WIDTH 80
#define SCREEN_HEIGHT 60
#define TEXTURE_WIDTH 64
#define TEXTURE_HEIGHT 64
#define TILE_WIDTH 64
#define TILE_HEIGHT 64
#define WALL_LAYER 20
#define FLOOR_LAYER 10
#define TICK_LAG 0.5

#define INPUT_DPAD			1
#define INPUT_ANALOG		2
#define INPUT_FIRE			3
#define TAP_DURATION 1.5

#define floor(X) round((X))
#define clamp(X,Y,Z) min(max((X),(Y)),(Z))

proc/atan2(x, y) return (x || y) && (x >= 0 ? arccos(y / sqrt(x * x + y * y)) : 360 - arccos(y / sqrt(x * x + y * y)))

#define WEAPON_LAYER 21

proc
	ang2dir(a)
		while(a<0)
			a += 360
		while(a>360)
			a -= 360
		if(a>=0&&a<=22.5)
			return NORTH
		if(a>22.5&&a<=67.5)
			return NORTHEAST
		if(a>67.5&&a<=112.5)
			return EAST
		if(a>112.5&&a<=157.5)
			return SOUTHEAST
		if(a>157.5&&a<=202.5)
			return SOUTH
		if(a>202.5&&a<=247.5)
			return SOUTHWEST
		if(a>247.5&&a<=292.5)
			return WEST
		if(a>292.5&&a<=337.5)
			return NORTHWEST
		if(a>337.5)
			return NORTH