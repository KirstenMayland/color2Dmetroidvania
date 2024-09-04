1) make camera seperate from player (in core, just not in player)
2) make functioning character health bar
3) create some way to lock the bounds of the fighting arena for boss fights


enemies =========
- create boss fight in russet_grove_4

player ==========
- create death scene

levels ==========
- fix bug where it crashes after 1) starting game and switching scenes 2) pausing and exitting to main menu 3) trying to start again
- when boss fight starts, camera stablizes to the middle of the screen

UI ==============
- create a settings screen
- add save feature to main menu

visuals =========
- add landing pixels when player transitions between landing and walking (instead of landing to idle)
- add parallax backgrounds
- add slowly moving floating particle effects (like r_g_1 but moving )
- create foreground visuals

components ======
- create velocity component
- create pathfind component
- create basic statemachine class component
- status reciever component

other ===========
- change that the same button to interact with buttons (click), is the same to slash




NOTES:
	Player exists on level 2, all non-damaging things or entities exist on level 1 or no level
	- Player HURTBOX exists on level 2, Player weapon HITBOX exists on level 3
		- checks for damage coming from level 4 (things that hurt)
	- Enemies/things that can hurt exist on level 4
		- checks for damage coming from level 3 (player weapon hitbox)
		
	Player Hitbox = 2
	Player Hurtbox = 3
	Enemy Hitbox = 3
	Enemy Hurtbox = 2
		
Hitboxes DEAL damage
Hurtboxes RECEIVE damage
