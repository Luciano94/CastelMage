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
	public var player:Player;
	private var hud:HUD;
	private var playerHealth:FlxBar;
	private var score:Int;
	
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
		
		
		backdrop = new FlxBackdrop(AssetPaths.backdrop__png, 0.5, 0.25, true, true, 0, 0);
		add(backdrop);

		tilemapSetUp();
		loader.loadEntities(entityCreator, "Entities");
		boss = new Boss(400, 400, player);
		
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
		add(secretWays);
		add(boss);
		
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
		
		//cameraHandling();

		hud.updateHUD(Player.lives, player.weaponCurrentState.getName(), player.ammo, Reg.score, Reg.paused);
		
		if (player.hasLost)
		{
			openSubState(new DeathState());
		}
	}
	
	function colWeaPotTile(w:WeaponPotion, b:Bat) 
	{
		w.set_isItTouching(true);
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
				var boss = new Boss(x, y, player);
				add(boss);
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
		//camera.setScrollBoundsRect(0, player.y - 128, 6400, player.y + 32);
	}

	private function hudSetUp():Void
	{
		hud = new HUD(player);
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
		Reg.score += 1;
	}

	private function colWeaponChaman(w:WeaponBase, c:Chaman):Void
	{
		switch (w.getType())
		{
			case "Normal":
				c.getDamage(Reg.playerNormalDamage);
			case "Spear":
				c.getDamage(Reg.spearDamage);
			case "Shuriken":
				c.getDamage(Reg.shurikenDamage);
			case "Poison":
				c.getDamage(Reg.poisonDamage);
			default:
		}
	}

	private function colWeaponZombie(w:WeaponBase, z:Zombie):Void
	{
		switch (w.getType())
		{
			case "Normal":
				z.getDamage(Reg.playerNormalDamage);
			case "Spear":
				z.getDamage(Reg.spearDamage);
			case "Shuriken":
				z.getDamage(Reg.shurikenDamage);
			case "Poison":
				z.getDamage(Reg.poisonDamage);
			default:
		}
	}

	private function colWeaponArEnemy(w:WeaponBase, a:ArmoredEnemy):Void
	{
		if (a.getState() == State.ATTACKING)
			switch (w.getType())
			{
				case "Normal":
					a.getDamage(Reg.playerNormalDamage);
				case "Spear":
					a.getDamage(Reg.spearDamage);
				case "Shuriken":
					a.getDamage(Reg.shurikenDamage);
				case "Poison":
					a.getDamage(Reg.poisonDamage);
				default:
			}
	}

	private function colWeaponMinion(w:WeaponBase, m:Minion):Void
	{
		m.kill();
		Reg.score += 3;
	}
	
	// Weapon - Obstacles
	private function weaponBarrelCollision(w:WeaponNormal, b:Barrel):Void
	{
		b.preKill(powerUps);
	}
	
	// Player - Enemies
	private function colPlayerBat(p:Player, b:Bat):Void
	{
		p.getDamage(Reg.batAtkDamage);
		if (p.x > b.x)
		{
			p.x += 32;
			b.x -= 32;
		}
		else
		{
			p.x -= 32;
			b.x += 32;
		}
	}

	private function colPlayerChaman(p:Player, c:Chaman):Void
	{
		p.getDamage(Reg.shamanAtkDamage);
		if (p.x > c.x)
		{
			p.x += 32;
			c.x -= 32;
		}
		else
		{
			p.x -= 32;
			c.x += 32;
		}
	}

	private function colPlayerZombie(p:Player, z:Zombie):Void
	{
		p.getDamage(Reg.zombieAtkDamage);
		if (p.x > z.x)
		{
			p.x += 32;
			z.x -= 32;
		}
		else
		{
			p.x -= 32;
			z.x += 32;
		}
	}

	private function colPayerArEnemy(p:Player, a:ArmoredEnemy):Void
	{
		p.getDamage(Reg.armoredEnemyAtkDamage);
		if (p.x > a.x)
		{
			p.x += 32;
			a.x -= 32;
		}
		else
		{
			p.x -= 32;
			a.x += 32;
		}
	}

	private function colPlayerMinion(p:Player, m:Minion): Void
	{
		p.getDamage(Reg.minionAtkDamage);
		if (p.x > m.x)
		{
			p.x += 32;
			m.x -= 32;
		}
		else
		{
			p.x -= 32;
			m.x += 32;
		}
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
}