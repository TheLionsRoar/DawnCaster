#define PISTOL_SHOOT "pistol shoot"
#define PISTOL_RELOAD "pistol reload"
#define MGUN_SHOOT "mgun shoot"
#define MONSTER_DIE1 "monster die1"
#define MONSTER_DIE2 "monster die2"
#define MONSTER_DIE3 "monster die3"
#define MONSTER_DIE4 "monster die4"
#define MONSTER_ATTACK1 "monster attack1"
#define MONSTER_ATTACK2 "monster attack2"
#define MONSTER_ATTACK3 "monster attack3"
#define MUSIC1 "music1"
#define PICKUP_PISTOL_AMMO "pickup pistol ammo"
#define PICKUP_HEALTHPACK "pickup healthpack"
#define PICKUP_ARMOR "pickup armor"
#define PICKUP_KEY "pickup key"
#define DOOR_OPEN "door open"

world
	New()
		. = ..()
		gen_sounds()

var
	list/sounds = list()

proc
	gen_sounds()
		var/sound/sound = sound('sound/synthetic_gunshot_2.ogg')
		sound.volume = 75
		sound.frequency = 3.5
		sounds[PISTOL_SHOOT] = sound
		sound = sound('sound/us_quarter.ogg')
		sound.volume = 100
		sound.frequency = 1.5
		sounds[PISTOL_RELOAD] = sound
		sound = sound('sound/synthetic_gunshot_2.ogg')
		sound.volume = 50
		sound.frequency = 5
		sounds[MGUN_SHOOT] = sound
		sound = sound('sound/monster_die.ogg')
		sound.volume = 75
		sound.frequency = 3
		sounds[MONSTER_DIE1] = sound
		sound = sound('sound/monster_die.ogg')
		sound.volume = 75
		sound.frequency = 2.5
		sounds[MONSTER_DIE2] = sound
		sound = sound('sound/monster_die.ogg')
		sound.volume = 75
		sound.frequency = 4
		sounds[MONSTER_DIE3] = sound
		sound = sound('sound/monster_die.ogg')
		sound.volume = 75
		sound.frequency = 2
		sounds[MONSTER_DIE4] = sound
		sound = sound('sound/monster_trill.ogg')
		sound.volume = 100
		sound.frequency = 2.5
		sounds[MONSTER_ATTACK1] = sound
		sound = sound('sound/monster_trill.ogg')
		sound.volume = 100
		sound.frequency = 4
		sounds[MONSTER_ATTACK2] = sound
		sound = sound('sound/monster_trill.ogg')
		sound.volume = 100
		sound.frequency = 1.5
		sounds[MONSTER_ATTACK3] = sound
		sound = sound('sound/Thrust Sequence.ogg')
		sound.volume = 50
		sound.repeat = 1
		sounds[MUSIC1] = sound
		sound = sound('sound/armor_pickup.ogg')
		sound.volume = 75
		sounds[PICKUP_ARMOR] = sound
		sound = sound('sound/health_pickup.ogg')
		sound.volume = 75
		sounds[PICKUP_HEALTHPACK] = sound
		sound = sound('sound/ammo_pickup.ogg')
		sound.frequency = 0.75
		sound.volume = 75
		sounds[PICKUP_PISTOL_AMMO] = sound
		sound = sound('sound/key_pickup.ogg')
		sound.frequency = 0.75
		sound.volume = 75
		sounds[PICKUP_KEY] = sound
		sound = sound('sound/metalbang8.ogg')
		sound.frequency = 0.8
		sound.volume = 100
		sounds[DOOR_OPEN] = sound