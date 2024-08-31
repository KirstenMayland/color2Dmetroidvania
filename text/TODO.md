enemies =========
- add boss to russet_grove_4

player ==========
- redesign character swing

levels ==========
- fix bug where it crashes after 1) starting game and switching scenes 2) pausing and exitting to main menu 3) trying to start again

UI ==============
- create a settings screen
- create a pause screen
- create a character health bar
- add save feature to main menu

visuals =========
- add landing pixels when transitioning between landing and walking

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
