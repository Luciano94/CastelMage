package states;

import entities.Player.WeaponStates;
import entities.Player;
import entities.PowerUp;
import entities.WeaponBase;
import entities.obstacles.Barrel;
import entities.obstacles.Elevator;
import entities.obstacles.Ladder;
import entities.obstacles.MovingPlatform;
import entities.obstacles.OneWayPlatform;
import entities.weapons.WeaponNormal;
import flixel.FlxCamera;
import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.editors.ogmo.FlxOgmoLoader;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tile.FlxTileblock;
import flixel.tile.FlxTilemap;
import flixel.FlxObject;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;
import entities.enemies.ArmoredEnemy;
import entities.enemies.ArmoredEnemy.State;
import entities.enemies.Bat;
import entities.enemies.Chaman;
import entities.enemies.Minion;
import entities.enemies.Zombie;

class PlayState extends FlxState
{
	// Player
	public var player:Player;
	private var hud:HUD;
	private var playerHealth:FlxBar;
	private var score:Int;

	//Tilemap
	private var loader:FlxOgmoLoader;
	private var tilemap:FlxTilemap;

	//Obstacles
	private var ladders:FlxTypedGroup<Ladder>;
	private var oneWayPlatforms:FlxTypedGroup<OneWayPlatform>;
	private var movingPlatforms:FlxTypedGroup<MovingPlatform>;
	private var elevators:FlxTypedGroup<Elevator>;
	private var platformLimits:FlxTypedGroup<FlxSprite>;
	private var barrels:FlxTypedGroup<Barrel>;

	// Enemies
	private var batGroup:FlxTypedGroup<Bat>;
	private var shamanGroup:FlxTypedGroup<Chaman>;
	private var minionGroup:FlxTypedGroup<Minion>;
	private var arEnemyGroup:FlxTypedGroup<ArmoredEnemy>;
	private var zombieGroup:FlxTypedGroup<Zombie>;

	override public function create():Void
	{
		super.create();

		score = 0;
		
		FlxG.worldBounds.set(0, 0, 5120, 640);
		FlxG.mouse.visible = false;

		//Obstacles Intitialization
		ladders = new FlxTypedGroup<Ladder>();
		oneWayPlatforms = new FlxTypedGroup<OneWayPlatform>();
		movingPlatforms = new FlxTypedGroup<MovingPlatform>();
		elevators = new FlxTypedGroup<Elevator>();
		platformLimits = new FlxTypedGroup<FlxSprite>();
		barrels = new FlxTypedGroup<Barrel>();

		//Enemies Initialization
		batGroup = new FlxTypedGroup<Bat>();
		zombieGroup = new FlxTypedGroup<Zombie>();
		shamanGroup = new FlxTypedGroup<Chaman>();
		arEnemyGroup = new FlxTypedGroup<ArmoredEnemy>();
		minionGroup = new FlxTypedGroup<Minion>();

		tilemapSetUp();
		loader.loadEntities(entityCreator, "Entities");
		
		add(ladders);
		add(oneWayPlatforms);
		add(movingPlatforms);
		add(elevators);
		add(platformLimits);
		add(barrels);
		add(batGroup);
		add(zombieGroup);
		add(shamanGroup);
		add(arEnemyGroup);
		add(minionGroup);
		add(player);
		
		cameraSetUp();
		hudSetUp();
	}

	override public function update(elapsed:Float):Void
	{
		if (!Reg.paused)
			super.update(elapsed);
		
		// COLLISIONS
		// Entities - Tilemap
		FlxG.collide(player, tilemap);
		FlxG.collide(zombieGroup, tilemap);
		FlxG.collide(shamanGroup, tilemap);
		FlxG.collide(arEnemyGroup, tilemap);
		FlxG.collide(minionGroup, tilemap);
		// Player - Obstacles
		ladderOverlapChecking();
		FlxG.overlap(player, ladders, playerLadderCollision);
		FlxG.collide(player, oneWayPlatforms);
		FlxG.collide(player, movingPlatforms);
		FlxG.collide(player, elevators);
		// Moving Platforms - Boundaries
		FlxG.overlap(elevators, platformLimits, changeElevatorDirection);
		FlxG.overlap(movingPlatforms, platformLimits, changeMovingPlatformDirection);
		// Player - Enemies
		FlxG.collide(player, batGroup, colPlayerBat);
		FlxG.collide(player, shamanGroup, colPlayerChaman);
		FlxG.collide(player, zombieGroup, colPlayerZombie);
		FlxG.collide(player, arEnemyGroup, colPayerArEnemy);
		FlxG.collide(player, minionGroup, colPlayerMinion);
		// Main Weapon - Enemies
		FlxG.overlap(player.weaponN, batGroup, colWeaponBat);
		FlxG.overlap(player.weaponN, shamanGroup, colWeaponChaman);
		FlxG.overlap(player.weaponN, zombieGroup, colWeaponZombie);
		FlxG.overlap(player.weaponN, arEnemyGroup, colWeaponArEnemy);
		FlxG.overlap(player.weaponN, minionGroup, colWeaponMinion);
		// Secondary Weapon - Enemies
		FlxG.overlap(player.getSecondaryWeapon(), batGroup, colWeaponBat);
		FlxG.overlap(player.getSecondaryWeapon(), shamanGroup, colWeaponChaman);
		FlxG.overlap(player.getSecondaryWeapon(), zombieGroup, colWeaponZombie);
		FlxG.overlap(player.getSecondaryWeapon(), arEnemyGroup, colWeaponArEnemy);
		FlxG.overlap(player.getSecondaryWeapon(), minionGroup, colWeaponMinion);
		// Main Weapon - Obstacles
		FlxG.overlap(player.weaponN, barrels, weaponBarrelCollision);
		
		checkPause();
		hud.updateHUD(player.lives, player.weaponCurrentState.getName(), player.ammo, score, Reg.paused);
	}

	private function entityCreator(entityName:String, entityData:Xml):Void
	{
		var x:Int = Std.parseInt(entityData.get("x"));
		var y:Int = Std.parseInt(entityData.get("y"));

		switch (entityName)
		{
			// Player
			case "Player":
				player = new Player(x, y);
			// Obstacles
			case "Ladder":
				var ladder = new Ladder(x, y);
				ladders.add(ladder);
			case "OneWayPlatform":
				var oneWayPlatform = new OneWayPlatform(x, y);
				oneWayPlatforms.add(oneWayPlatform);
			case "MovingPlatform":
				var movingPlatform = new MovingPlatform(x, y);
				movingPlatforms.add(movingPlatform);
			case "Elevator":
				var elevator = new Elevator(x, y);
				elevators.add(elevator);
			case "PlatformLimit":
				var platformLimit = new FlxSprite(x, y);
				platformLimit.makeGraphic(16, 16, 0x00000000);
				platformLimits.add(platformLimit);
			case "Barrel":
				var barrel = new Barrel(x, y);
				barrels.add(barrel);
			// Enemies
			case "Bat":
				var bat = new Bat(x, y, player);
				batGroup.add(bat);
			case "Zombie":
				var zombie = new Zombie(x, y, player);
				zombieGroup.add(zombie);
			case "Shaman":
				var shaman = new Chaman(x, y, player, minionGroup);
				shamanGroup.add(shaman);
			case "ArmoredEnemy":
				var armoredEnemy = new ArmoredEnemy(x, y, player);
				arEnemyGroup.add(armoredEnemy);
		}
	}

	private function checkPause():Void
	{
		if (FlxG.keys.justPressed.ENTER)
			Reg.paused = !Reg.paused;
	}

	private function tilemapSetUp():Void
	{
		loader = new FlxOgmoLoader(AssetPaths.Level__oel);
		tilemap = loader.loadTilemap(AssetPaths.tileset__png, 16, 16, "Tiles");
		tilemap.setTileProperties(0, FlxObject.NONE);
		for (i in 1...3)
			tilemap.setTileProperties(i, FlxObject.ANY);
		for (i in 4...21)
			tilemap.setTileProperties(i, FlxObject.NONE);
		add(tilemap);
	}

	private function cameraSetUp():Void
	{
		camera.follow(player);
		camera.followLerp = 2;
		camera.targetOffset.set(0, -64);
		camera.setScrollBounds(0, 5120, 0, 640);
	}

	private function hudSetUp():Void
	{
		hud = new HUD(player);
		add(hud);
	}
	
	// COLLISION FUNCTIONS
	// Player - Ladders 
	private function ladderOverlapChecking():Void
	{
		if (FlxG.overlap(player, ladders))
		{
			player.isTouchingLadder = true;
		}
		else
		{
			player.isTouchingLadder = false;
			player.isOnTopOfLadder = false;
		}
	}

	private function playerLadderCollision(p:Player, l:Ladder):Void
	{
		if (p.y < l.y && p.currentState.getName() != "CLIMBING_LADDERS")
		{
			p.isOnTopOfLadder = true;
			FlxG.collide(p, l);
		}
		else 
			if (p.currentState.getName() == "CLIMBING_LADDERS")
			{
				p.isOnTopOfLadder = false;
				p.x = l.x;
			}
	}
	
	// Elevator - Boundaries
	private function changeElevatorDirection(e:Elevator, l:FlxSprite):Void
	{
		if (e.direction == FlxObject.DOWN && !e.hasJustChangedDirection)
		{
			e.direction = FlxObject.UP;
			e.hasJustChangedDirection = true;
		}
		else
		{
			if (!e.hasJustChangedDirection)
			{
				e.direction = FlxObject.DOWN;
				e.hasJustChangedDirection = true;
			}
		}
	}
		
	private function changeMovingPlatformDirection(m:MovingPlatform, l:FlxSprite):Void
	{
		if (m.direction == FlxObject.RIGHT && !m.hasJustChangedDirection)
		{
			m.direction = FlxObject.LEFT;
			m.hasJustChangedDirection = true;
		}
		else
		{
			if (!m.hasJustChangedDirection)
			{
				m.direction = FlxObject.RIGHT;
				m.hasJustChangedDirection = true;
			}
		}
	}
	
	// Weapon - Enemies
	private function colWeaponBat(w:WeaponBase, b:Bat):Void
	{
		b.kill();
	}

	private function colWeaponChaman(w:WeaponBase, c:Chaman):Void
	{
		c.kill();
	}

	private function colWeaponZombie(w:WeaponBase, z:Zombie):Void
	{
		z.kill();
	}

	private function colWeaponArEnemy(w:WeaponBase, a:ArmoredEnemy):Void
	{
		if (a.getState() == State.ATTACKING)
			a.getDamage();
	}

	private function colWeaponMinion(w:WeaponBase, m:Minion):Void
	{
		m.kill();
	}
	
	// Weapon - Obstacles
	private function weaponBarrelCollision(w:WeaponNormal, b:Barrel):Void
	{
		b.preKill();
	}
	
	// Player - Enemies
	private function colPlayerBat(p:Player, b:Bat):Void
	{
		p.getDamage(Reg.batAtkDamage);
	}

	private function colPlayerChaman(p:Player, c:Chaman):Void
	{
		p.getDamage(Reg.shamanAtkDamage);
	}

	private function colPlayerZombie(p:Player, z:Zombie):Void
	{
		p.getDamage(Reg.zombieAtkDamage);
	}

	private function colPayerArEnemy(p:Player, a:ArmoredEnemy):Void
	{
		p.getDamage(Reg.armoredEnemyAtkDamage);
	}

	private function colPlayerMinion(p:Player, m:Minion): Void
	{
		p.getDamage(Reg.minionAtkDamage);
	}
}