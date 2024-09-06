Necessary To Publish Demo:
1) boss fight
	1.1) lock camera in center during boss fight
	1.2) create some way to lock the bounds of the fighting arena for boss fights
	1.3) at least 3 different attack types
	1.4) boss health bar (if no stagger)
2) interactable character in the hut in room 3
3) name the game
4) make it so that mouse only appears in a menu screen
5) revert back to autofull screen, no boundaries
6) finish shading all the trees
7) "the end" or option to respawn if dead


enemies =========
- make it so that if the sheep can't locate us or we are dead it does its own thing
- -------------- Grove Guardian
	- create boss fight in russet_grove_4
	- enemy attack: the red orbs floating around the world open an eye and do damage of some sort (eg. passive damage, fly at player, pop, etc.)
	- make improve grove guardian grass in idle animation

player ==========
- create some signifier when < 20% health left
- fix death scene so that the melt doesn't hang in the air
	- create death scene when you die in mid-air or on spikes or something similarly less stable

levels ==========
- fix bug where it crashes after 1) starting game and switching scenes 2) pausing and exitting to main menu 3) trying to start again

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
