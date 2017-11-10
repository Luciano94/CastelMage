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
import entities.obstacles.UnstablePlatform;
import entities.weapons.WeaponNormal;
import entities.weapons.WeaponPotion;
import flixel.FlxCamera;
import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxBackdrop;
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
import entities.enemies.Boss;

class PlayState extends FlxState
{
	// Player
	private var player:Player;
	private var hud:HUD;
	private var playerHealth:FlxBar;
	
	// Tilemap
	private var loader:FlxOgmoLoader;
	private var tilemap:FlxTilemap;
	private var backdrop:FlxBackdrop;

	// Obstacles
	private var ladders:FlxTypedGroup<Ladder>;
	private var oneWayPlatforms:FlxTypedGroup<OneWayPlatform>;
	private var movingPlatforms:FlxTypedGroup<MovingPlatform>;
	private var elevators:FlxTypedGroup<Elevator>;
	private var platformLimits:FlxTypedGroup<FlxSprite>;
	private var barrels:FlxTypedGroup<Barrel>;
	private var unstablePlatforms:FlxTypedGroup<UnstablePlatform>;
	private var secretWays:FlxTypedGroup<FlxSprite>;
	
	// Power Up
	private var powerUps:FlxTypedGroup<PowerUp>;

	// Enemies
	private var batGroup:FlxTypedGroup<Bat>;
	private var shamanGroup:FlxTypedGroup<Chaman>;
	private var minionGroup:FlxTypedGroup<Minion>;
	private var arEnemyGroup:FlxTypedGroup<ArmoredEnemy>;
	private var zombieGroup:FlxTypedGroup<Zombie>;
	private var boss:Boss;

	override public function create():Void
	{
		FlxG.camera.fade(FlxColor.BLACK, 0.5, true);
		
		super.create();
		
		FlxG.worldBounds.set(0, 0, 6400, 640);
		FlxG.mouse.visible = false;

		// Obstacles Intitialization
		ladders = new FlxTypedGroup<Ladder>();
		oneWayPlatforms = new FlxTypedGroup<OneWayPlatform>();
		movingPlatforms = new FlxTypedGroup<MovingPlatform>();
		elevators = new FlxTypedGroup<Elevator>();
		platformLimits = new FlxTypedGroup<FlxSprite>();
		barrels = new FlxTypedGroup<Barrel>();
		unstablePlatforms = new FlxTypedGroup<UnstablePlatform>();
		secretWays = new FlxTypedGroup<FlxSprite>();

		// Power Ups Inicialization
		powerUps = new FlxTypedGroup<PowerUp>();

		// Enemies Initialization
		batGroup = new FlxTypedGroup<Bat>();
		zombieGroup = new FlxTypedGroup<Zombie>();
		shamanGroup = new FlxTypedGroup<Chaman>();
		arEnemyGroup = new FlxTypedGroup<ArmoredEnemy>();
		minionGroup = new FlxTypedGroup<Minion>();
		
		//Backdrop Instantiation
		backdrop = new FlxBackdrop(AssetPaths.backdrop__png, 0.5, 0.25, true, true, 0, 0);
		add(backdrop);
		
		// Tilemap, Player & Entities
		tilemapSetUp();
		player = new Player();
		loader.loadEntities(entityCreator, "Entities");
		
		// Adds
		add(ladders);
		add(oneWayPlatforms);
		add(movingPlatforms);
		add(elevators);
		add(platformLimits);
		add(barrels);
		add(unstablePlatforms);
		add(powerUps);
		add(batGroup);
		add(zombieGroup);
		add(shamanGroup);
		add(arEnemyGroup);
		add(minionGroup);
		add(player);
		add(boss);
		add(secretWays);
		
		cameraSetUp();
		hudSetUp();
		
		FlxG.sound.playMusic(AssetPaths.theme__wav, 1, true);
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
		FlxG.collide(player.get_weaponPotion(), tilemap, colWeaPotTile);

		// Player - Obstacles
		ladderOverlapChecking();
		FlxG.overlap(player, ladders, playerLadderCollision);
		FlxG.collide(player, oneWayPlatforms);
		FlxG.collide(player, movingPlatforms);
		FlxG.collide(player, elevators);
		FlxG.collide(player, unstablePlatforms, playerUnstablePlatformCollision);
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
		// Player - Power Ups
		FlxG.overlap(player, powerUps, playerPowerUpCollision);
		
		checkPause();
		checkEscape();
		
		hud.updateHUD(Player.lives, player.weaponCurrentState.getName(), player.ammo, Reg.score, Reg.paused, boss.hasAppeared);
		
		if (player.hasLost)
			openSubState(new DeathState());
		else
			if (player.hasWon)
			{
				hud.visible = false;
				Reg.highestScore = Reg.score;
				openSubState(new WinState());
			}
	}
	
	private function entityCreator(entityName:String, entityData:Xml):Void
	{
		var x:Int = Std.parseInt(entityData.get("x"));
		var y:Int = Std.parseInt(entityData.get("y"));

		switch (entityName)
		{
			// Player
			case "Player":
				player.setPosition(x, y);	// It's not the prettiest thing, but it does the trick.
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
			case "UnstablePlatform":
				var unstablePlatform = new UnstablePlatform(x, y);
				unstablePlatforms.add(unstablePlatform);
			case "SecretWay":
				var secretWay = new FlxSprite(x, y, AssetPaths.secretWay__png);
				secretWays.add(secretWay);
			case "PowerUp":
				var powerUp = new PowerUp(x, y, Reg.random.int(0, Reg.numberOfPowerUps));
				powerUps.add(powerUp);
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
			case "Boss":
				boss = new Boss(x, y, player);
		}
	}

	private function checkPause():Void
	{
		if (FlxG.keys.justPressed.ENTER)
		{
			FlxG.sound.play(AssetPaths.menuSelection__wav);
			Reg.paused = !Reg.paused;
		}
	}
	
	private function checkEscape():Void
	{
		if (FlxG.keys.justPressed.ESCAPE)
		{
			Player.setLives(Reg.playerMaxLives);
			Reg.score = 0;
			Reg.paused = false;
			FlxG.mouse.visible = true;
			FlxG.switchState(new MenuState());	
		}
	}

	private function tilemapSetUp():Void
	{
		loader = new FlxOgmoLoader(AssetPaths.Level__oel);
		tilemap = loader.loadTilemap(AssetPaths.tileset__png, 16, 16, "Tiles");
		tilemap.setTileProperties(0, FlxObject.NONE);
		for (i in 1...3)
			tilemap.setTileProperties(i, FlxObject.ANY);
		for (i in 4...18)
			tilemap.setTileProperties(i, FlxObject.NONE);
		tilemap.setTileProperties(19, FlxObject.ANY);
		tilemap.setTileProperties(20, FlxObject.NONE);
		add(tilemap);
	}

	private function cameraSetUp():Void
	{
		camera.follow(player);
		camera.followLerp = 2;
		camera.targetOffset.set(0, -64);
		camera.setScrollBounds(0, 6400, 0, 640);
	}

	private function hudSetUp():Void
	{
		hud = new HUD(player, boss);
		add(hud);
	}
	
	private function cameraHandling():Void 
	{
		if (player.y > camera.scroll.y + FlxG.height)
			camera.setScrollBoundsRect(0, camera.scroll.y + FlxG.height, 6400, camera.scroll.y + 2 * FlxG.height);
		else
			if (player.y < camera.scroll.y)
				camera.setScrollBoundsRect(0, camera.scroll.y - FlxG.height, 6400, camera.scroll.y); 
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

		if (p.y > l.y && p.currentState.getName() != "CLIMBING_LADDERS")
			p.isUnderLadder = true;
		else
			p.isUnderLadder = false;
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
	
	// Player - Unstable Platform
	private function playerUnstablePlatformCollision(p:Player, u:UnstablePlatform):Void
	{
		u.playerIsOnTop = true;
	}
	
	// Weapon - Enemies
	private function colWeaponBat(w:WeaponBase, b:Bat):Void
	{
		b.kill();
	}

	private function colWeaponChaman(w:WeaponBase, c:Chaman):Void
	{
		weaponEnemyDamage(w, c);
	}

	private function colWeaponZombie(w:WeaponBase, z:Zombie):Void
	{
		weaponEnemyDamage(w, z);
	}

	private function colWeaponArEnemy(w:WeaponBase, a:ArmoredEnemy):Void
	{
		if (a.getState() == State.ATTACKING)
			weaponEnemyDamage(w, a);
	}

	private function colWeaponMinion(w:WeaponBase, m:Minion):Void
	{
		weaponEnemyDamage(w, m);
	}
	
	// Weapon - Obstacles
	private function weaponBarrelCollision(w:WeaponNormal, b:Barrel):Void
	{
		b.preKill(powerUps);
	}
	
	private function colWeaPotTile(w:WeaponPotion, b:Bat):Void
	{
		w.set_isItTouching(true);
	}
	
	// Player - Enemies
	private function colPlayerBat(p:Player, b:Bat):Void
	{
		p.getDamage(Reg.batAtkDamage);
		playerEnemyImpact(p, b);
	}

	private function colPlayerChaman(p:Player, c:Chaman):Void
	{
		p.getDamage(Reg.shamanAtkDamage);
		playerEnemyImpact(p, c);
	}

	private function colPlayerZombie(p:Player, z:Zombie):Void
	{
		p.getDamage(Reg.zombieAtkDamage);
		playerEnemyImpact(p, z);
		z.hasJustAttacked = true;
		z.recoveryTime = 0;
		z.velocity.set(0, 0);
	}

	private function colPayerArEnemy(p:Player, a:ArmoredEnemy):Void
	{
		p.getDamage(Reg.armoredEnemyAtkDamage);
		playerEnemyImpact(p, a);
	}

	private function colPlayerMinion(p:Player, m:Minion): Void
	{
		p.getDamage(Reg.minionAtkDamage);
		playerEnemyImpact(p, m);
		m.hasJustAttacked = true;
		m.recoveryTime = 0;
		m.velocity.set(0, 0);
	}
	
	// Player - Power Ups
	private function playerPowerUpCollision(p:Player, pUp:PowerUp) 
	{
		p.collectPowerUp(pUp);	
		if (p.powerUpJustPicked)
		{
			powerUps.remove(pUp);
			p.powerUpJustPicked = false;
		}
	}
	
	private function playerEnemyImpact(p:Player, e):Void
	{
		if (p.x > e.x)
			p.velocity.x += 20;
		else
			p.velocity.x -= 20;
	}
	
	private function weaponEnemyDamage(w:WeaponBase, e):Void 
	{
		switch (w.getType())
		{
			case "Normal":
				e.getDamage(Reg.playerNormalDamage);
			case "Spear":
				e.getDamage(Reg.spearDamage);
			case "Shuriken":
				e.getDamage(Reg.shurikenDamage);
			case "Poison":
				e.getDamage(Reg.poisonDamage);
			default:
		}
	}
}