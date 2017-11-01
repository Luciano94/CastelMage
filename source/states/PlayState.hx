package states;

import entities.Player;
import entities.PowerUp;
import entities.enemies.ArmoredEnemy;
import entities.enemies.Bat;
import entities.enemies.Chaman;
import entities.enemies.Minion;
import entities.enemies.Zombie;
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

class PlayState extends FlxState
{
	// Player
	public var player:Player;
	private var loader:FlxOgmoLoader;
	private var tilemap:FlxTilemap;
	private var hud:HUD;
	private var playerHealth:FlxBar;
	private var score:Int;
	private var stairs:FlxTypedGroup<FlxSprite>;
	private var bats:FlxTypedGroup<Bat>;
	private var zombies:FlxTypedGroup<Zombie>;
	private var shamans:FlxTypedGroup<Chaman>;
	private var armoredEnemies:FlxTypedGroup<ArmoredEnemy>;
	private var minions:FlxTypedGroup<Minion>;

	override public function create():Void
	{
		super.create();
		
		FlxG.mouse.visible = false;
		score = 0;
		stairs = new FlxTypedGroup<FlxSprite>();
		bats = new FlxTypedGroup<Bat>();
		zombies = new FlxTypedGroup<Zombie>();
		shamans = new FlxTypedGroup<Chaman>();
		armoredEnemies = new FlxTypedGroup<ArmoredEnemy>();
		minions = new FlxTypedGroup<Minion>();
		
		tilemapSetUp();
		loader.loadEntities(entityCreator, "Entities");
		add(stairs);
		add(bats);
		add(zombies);
		add(shamans);
		add(armoredEnemies);
		add(minions);
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
		FlxG.collide(zombies, tilemap);
		FlxG.collide(shamans, tilemap);
		FlxG.collide(armoredEnemies, tilemap);
		FlxG.collide(minions, tilemap);
		playerTouchStairs();
		
		checkPause();
		hud.updateHUD(player.lives, player.weaponCurrentState.getName(), player.ammo, score, Reg.paused);
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
				var stair = new FlxSprite(x, y);
				stair.loadGraphic(AssetPaths.stairs__png, true, 16, 16);
				stairs.add(stair);
			case "Bat":
				var bat = new Bat(x, y, player);
				bats.add(bat);
			case "Zombie":
				var zombie = new Zombie(x, y, player);
				zombies.add(zombie);
			case "Shaman":
				var shaman = new Chaman(x, y, player, minions);
				shamans.add(shaman);
			case "ArmoredEnemy":
				var armoredEnemy = new ArmoredEnemy(x, y, player);
				armoredEnemies.add(armoredEnemy);
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
	
	private function playerTouchStairs():Void 
	{
		if (FlxG.overlap(player, stairs))
		{
			player.isStepingStairs = true;
		}
		else
			player.isStepingStairs = false;
	}
}