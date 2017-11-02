package states;

import entities.Player.WeaponStates;
import entities.Player;
import entities.PowerUp;
import entities.WeaponBase;
import entities.weapons.WeaponNormal;
import flixel.FlxCamera;
import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.editors.ogmo.FlxOgmoLoader;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
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
	
	//Environment
	private var loader:FlxOgmoLoader;
	private var tilemap:FlxTilemap;
	private var ladders:FlxTypedGroup<FlxSprite>;
	
	// Enemies
	private var batGroup:FlxTypedGroup<Bat>;
	private var shamanGroup:FlxTypedGroup<Chaman>;
	private var minionGroup:FlxTypedGroup<Minion>;
	private var arEnemyGroup:FlxTypedGroup<ArmoredEnemy>;
	private var zombieGroup:FlxTypedGroup<Zombie>;

	override public function create():Void
	{
		super.create();
		
		FlxG.mouse.visible = false;
		score = 0;
		ladders = new FlxTypedGroup<FlxSprite>();
		batGroup = new FlxTypedGroup<Bat>();
		zombieGroup = new FlxTypedGroup<Zombie>();
		shamanGroup = new FlxTypedGroup<Chaman>();
		arEnemyGroup = new FlxTypedGroup<ArmoredEnemy>();
		minionGroup = new FlxTypedGroup<Minion>();
		
		tilemapSetUp();
		loader.loadEntities(entityCreator, "Entities");
		add(ladders);
		add(batGroup);
		add(zombieGroup);
		add(shamanGroup);
		add(arEnemyGroup);
		add(minionGroup);
		add(player);
		
		FlxG.worldBounds.set(0, 0, 5120, 512);
		cameraSetUp();
		hudSetUp();	
	}

	override public function update(elapsed:Float):Void
	{
		if (!Reg.paused)
		{
			super.update(elapsed);
		}
		FlxG.collide(player, tilemap);
		FlxG.collide(zombieGroup, tilemap);
		FlxG.collide(shamanGroup, tilemap);
		FlxG.collide(arEnemyGroup, tilemap);
		FlxG.collide(minionGroup, tilemap);
		
		ladderOverlapChecking();
		FlxG.overlap(player, ladders, playerLadderCollision);
		
		checkPause();
		hud.updateHUD(player.lives, player.weaponCurrentState.getName(), player.ammo, score, Reg.paused);
		// Player - Enemies
		FlxG.collide(player, batGroup, colPlayerBat);
		FlxG.collide(player, shamanGroup, colPlayerChaman);
		FlxG.collide(player, zombieGroup, colPlayerZombie);
		FlxG.collide(player, arEnemyGroup, colPayerArEnemy);
		FlxG.collide(player, minionGroup, colPlayerMinion);
		//Weapon - Enemies
		FlxG.collide(player.getWeaponN(), batGroup, colWeaponBat);
		FlxG.collide(player.getWeaponN(), shamanGroup, colWeaponChaman);
		FlxG.collide(player.getWeaponN(), zombieGroup, colWeaponZombie);
		FlxG.collide(player.getWeaponN(), arEnemyGroup, colWeaponArEnemy);
		FlxG.collide(player.getWeaponN(), minionGroup, colWeaponMinion);
		
		FlxG.collide(player.getMainWeapon(), batGroup, colWeaponBat);
		FlxG.collide(player.getMainWeapon(), shamanGroup, colWeaponChaman);
		FlxG.collide(player.getMainWeapon(), zombieGroup, colWeaponZombie);
		FlxG.collide(player.getMainWeapon(), arEnemyGroup, colWeaponArEnemy);
		FlxG.collide(player.getMainWeapon(), minionGroup, colWeaponMinion);
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
	
	// Player - Enemies
	private function colPlayerBat(p:Player, b:Bat):Void
	{
		p.getDamage();
	}
	
	private function colPlayerChaman(p:Player, c:Chaman):Void
	{
		p.getDamage();
	}
	
	private function colPlayerZombie(p:Player, z:Zombie):Void
	{
		p.getDamage();
	}
	
	private function colPayerArEnemy(p:Player, a:ArmoredEnemy):Void
	{
		p.getDamage();
	}
	
	private function colPlayerMinion(p:Player, m:Minion): Void
	{
		p.getDamage();
	}

	private function entityCreator(entityName:String, entityData:Xml):Void
	{
		var x:Int = Std.parseInt(entityData.get("x"));
		var y:Int = Std.parseInt(entityData.get("y"));

		switch (entityName)
		{
			case "Player":
				player = new Player(x, y);
			case "Stairs":
				var ladder = new FlxSprite(x, y);
				ladder.immovable = true;
				ladder.loadGraphic(AssetPaths.ladder__png, true, 32, 128);
				ladders.add(ladder);
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
		for (i in 0...8)
			tilemap.setTileProperties(i, FlxObject.NONE);
		for (i in 8...10)
			tilemap.setTileProperties(i, FlxObject.ANY);
		for (i in 11...20)
			tilemap.setTileProperties(i, FlxObject.NONE);
		add(tilemap);
	}
	
	private function cameraSetUp():Void 
	{
		camera.follow(player);
		camera.setScrollBounds(0, 5120, 0, 512);
	}
	
	private function hudSetUp():Void 
	{
		hud = new HUD(player);
		add(hud);
	}
	
	private function ladderOverlapChecking():Void 
	{
		if (FlxG.overlap(player, ladders))
		{
			player.isTouchingLadder = true;
		}
		else
			player.isTouchingLadder = false;
	}
	
	private function playerLadderCollision(p:Player, l:FlxSprite):Void
	{
		if (p.y < l.y && p.currentState.getName() != "CLIMBING_LADDERS")
		{	
			FlxG.collide(p, l);
		}
		else
			if (p.currentState.getName() == "CLIMBING_LADDERS")
				p.x = l.x;	 
	}	
}