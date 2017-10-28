package states;

import entities.Player;
import entities.PowerUp;
import entities.weapons.WeaponNormal;
import flixel.FlxCamera;
import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.editors.ogmo.FlxOgmoLoader;
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

	override public function create():Void
	{
		super.create();
		
		//Hide Cursor
		FlxG.mouse.visible = false;
		
		//Tilemap
		loader = new FlxOgmoLoader(AssetPaths.Level__oel);
		tilemap = loader.loadTilemap(AssetPaths.tileset__png, 16, 16, "Tiles");
		for (i in 0...8)
			tilemap.setTileProperties(i, FlxObject.NONE);
		for (i in 8...10)
			tilemap.setTileProperties(i, FlxObject.ANY);
		for (i in 11...19)
			tilemap.setTileProperties(i, FlxObject.NONE);
		add(tilemap);

		//Loader && Bounds
		loader.loadEntities(entityCreator, "Entities");
		FlxG.worldBounds.set(0, 0, 5120, 512);

		//Camera
		camera.follow(player, FlxCameraFollowStyle.PLATFORMER, 2);
		camera.setScrollBounds(0, 5120, 0, 512);

		//HUD
		score = 0;
		
		hud = new HUD();
		add(hud);

		playerHealth = new FlxBar(10, 10, FlxBarFillDirection.LEFT_TO_RIGHT, 68, 12, player, "hp", 0, 100, true);
		playerHealth.scrollFactor.set(0, 0);
		add(playerHealth);	
	}

	override public function update(elapsed:Float):Void
	{
		if (!Reg.paused)
		{
			super.update(elapsed);
			
			hud.updateHUD(player.lives, player.weaponCurrentState.getName(), player.ammo, score);
		}
		FlxG.collide(player, tilemap);
		checkPause();
	}

	private function entityCreator(entityName:String, entityData:Xml):Void
	{
		var x:Int = Std.parseInt(entityData.get("x"));
		var y:Int = Std.parseInt(entityData.get("y"));

		switch (entityName)
		{
			case "Player":
				player = new Player(x, y);
				add(player);
		}
	}
	
	private function checkPause():Void
	{
		if (FlxG.keys.justPressed.ENTER)
			Reg.paused = !Reg.paused;
	}
}