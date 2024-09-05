1.2) lock camera in center during boss fight
2) create some way to lock the bounds of the fighting arena for boss fights


enemies =========
- create boss fight in russet_grove_4
- make it so that if the sheep can't locate us or we are dead it does its own thing

player ==========
- create some signifier when < 20% health left
- create death scene when you die in mid-air or on spikes or something similarly less stable

levels ==========
- fix bug where it crashes after 1) starting game and switching scenes 2) pausing and exitting to main menu 3) trying to start again
- when boss fight starts, camera stablizes to the middle of the screen

UI ==============
- create a settings screen
- add save feature to main menu

visuals =========
- add landing pixels when player transitions between landing and walking (instead of landing to idle) + fix getting stuck in that animation
		^ proposal, instead of the pixels being tied to the player animation, just have them seperate and have them appear for a blip whenever the player touches the ground

- add parallax backgrounds
- add slowly moving, floating red light particle effects (like russet_grove_1 but moving )
		^ add subemitter so red -> smaller orange; see if can add light
- create black foreground visuals

components ======
- create velocity component
- create pathfind component
- create basic statemachine class component
- status reciever component

other ===========




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
